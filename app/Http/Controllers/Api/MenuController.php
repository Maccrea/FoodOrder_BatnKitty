<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Menu;
use Illuminate\Http\Request;

class MenuController extends Controller
{
    public function index()
    {
        // Ambil semua menu yang statusnya aktif
        $menus = Menu::where('is_active', true)->get();
        
        return response()->json([
            'status' => 'success',
            'data' => $menus
        ]);
    }
}