<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\CustomerController;
use App\Http\Controllers\OrderController;

Route::post('/orders/{id}/mock-pay', [OrderController::class, 'mockPayment']);
Route::patch('/orders/{id}/kitchen', [OrderController::class, 'updateKitchenStatus']);
Route::patch('/orders/{id}/status', [OrderController::class, 'updateStatus']);
Route::post('/orders', [OrderController::class, 'store']);
Route::post('/customers', [CustomerController::class, 'store']);
Route::get('/menus', [MenuController::class, 'index']);
Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');
