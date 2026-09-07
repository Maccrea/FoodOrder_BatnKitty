<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'customer_id', 
        'tanggal_order', 
        'tanggal_pengambilan',
        'total_price', 
        'delivery_fee', 
        'delivery_type', 
        'delivery_address', 
        'status_bayar', 
        'status_masak',
        'status_pesanan',
        'approved_at',
        'completed_at'
    ];

    public function items()
    {
        return $this->hasMany(OrderItem::class);
    }
}