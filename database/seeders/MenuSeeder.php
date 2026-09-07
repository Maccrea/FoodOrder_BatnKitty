<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Menu; // Import model Menu

class MenuSeeder extends Seeder
{
    public function run(): void
    {
        Menu::create([
            'name' => 'Paket Katering Harian (Reguler)',
            'base_price' => 25000,
            'version' => 'v1.0',
            'category' => 'Harian',
            'is_active' => true
        ]);

        Menu::create([
            'name' => 'Paket Diet Mayo Spesial',
            'base_price' => 45000,
            'version' => 'v1.2',
            'category' => 'Diet',
            'is_active' => true
        ]);
    }
}