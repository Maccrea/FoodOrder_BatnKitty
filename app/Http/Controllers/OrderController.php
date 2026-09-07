<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class OrderController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'customer_id' => 'required|exists:customers,id',
            'tanggal_pengambilan' => 'required|date_format:Y-m-d H:i:s',
            'delivery_type' => 'required|string',
            'delivery_address' => 'nullable|string',
            'delivery_fee' => 'required|integer',
            'items' => 'required|array|min:1',
            'items.*.menu_name' => 'required|string',
            'items.*.quantity' => 'required|integer|min:1',
            'items.*.unit_price' => 'required|integer'
        ]);

        $waktuPengambilan = Carbon::parse($request->tanggal_pengambilan);
        $waktuSekarang = Carbon::now();

        if ($waktuSekarang->diffInHours($waktuPengambilan, false) < 4) {
            return response()->json([
                'status' => 'error',
                'message' => 'Pesanan ditolak! Waktu pengambilan minimal 4 jam dari sekarang.'
            ], 400);
        }

        $totalPrice = 0;
        foreach ($request->items as $item) {
            $totalPrice += ($item['quantity'] * $item['unit_price']);
        }
        $totalPrice += $request->delivery_fee;

        DB::beginTransaction();
        try {
            $order = Order::create([
                'customer_id' => $request->customer_id,
                'tanggal_order' => $waktuSekarang->format('Y-m-d H:i:s'),
                'tanggal_pengambilan' => $request->tanggal_pengambilan,
                'total_price' => $totalPrice,
                'delivery_fee' => $request->delivery_fee,
                'delivery_type' => $request->delivery_type,
                'delivery_address' => $request->delivery_address,
                'status_bayar' => 'unpaid',
                'status_masak' => 'Pending',
                'status_pesanan' => 'waiting_approve',
            ]);

            foreach ($request->items as $item) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'menu_name' => $item['menu_name'],
                    'quantity' => $item['quantity'],
                    'unit_price' => $item['unit_price'],
                    'custom_notes' => $item['custom_notes'] ?? null,
                ]);
            }

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Pesanan berhasil dibuat, menunggu persetujuan admin!',
                'data' => $order->load('items')
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack(); 
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal membuat pesanan: ' . $e->getMessage()
            ], 500);
        }
    }
    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status_pesanan' => 'required|in:approved,rejected,processing,completed,cancelled,expired'
        ]);

        $order = Order::find($id);
        
        if (!$order) {
            return response()->json([
                'status' => 'error',
                'message' => 'Pesanan tidak ditemukan!'
            ], 404);
        }

        $order->status_pesanan = $request->status_pesanan;

        if ($request->status_pesanan === 'approved') {
            $order->approved_at = Carbon::now();
        } 
        elseif ($request->status_pesanan === 'completed') {
            $order->completed_at = Carbon::now();
        }

        $order->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Status pesanan berhasil diperbarui menjadi: ' . $request->status_pesanan,
            'data' => $order
        ], 200);
    }
    public function updateKitchenStatus(Request $request, $id)
    {
        $request->validate([
            'status_masak' => 'required|in:Pending,Proses,Selesai'
        ]);

        $order = Order::find($id);
        
        if (!$order) {
            return response()->json([
                'status' => 'error',
                'message' => 'Pesanan tidak ditemukan!'
            ], 404);
        }

        if ($order->status_bayar !== 'paid') {
            return response()->json([
                'status' => 'error',
                'message' => 'Dapur belum bisa memproses! Pelanggan belum melakukan pembayaran.'
            ], 403);
        }

        $order->status_masak = $request->status_masak;
        $order->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Status dapur berhasil diupdate menjadi: ' . $request->status_masak,
            'data' => $order
        ], 200);
    }
    public function mockPayment($id)
    {
        $order = Order::find($id);
        
        if (!$order || $order->status_pesanan !== 'approved') {
            return response()->json([
                'status' => 'error',
                'message' => 'Pesanan tidak valid atau belum di-approve Admin.'
            ], 400);
        }

        $order->status_bayar = 'paid';
        $order->status_pesanan = 'processing';
        $order->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Simulasi pembayaran berhasil! Pesanan siap masuk dapur.',
            'data' => $order
        ], 200);
    }
}