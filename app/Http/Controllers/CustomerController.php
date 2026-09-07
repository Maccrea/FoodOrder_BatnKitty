<?php

namespace App\Http\Controllers;

use App\Models\Customer;
use Illuminate\Http\Request;

class CustomerController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|unique:customers,phone'
        ]);

        $customer = Customer::create([
            'name' => $request->name,
            'phone' => $request->phone
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Pelanggan berhasil ditambahkan!',
            'data' => $customer
        ], 201);
    }
}