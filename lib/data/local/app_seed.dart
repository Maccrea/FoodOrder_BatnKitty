const appSeed = {
  'users': [
    {
      'id': 1,
      'name': 'Admin BatKitty',
      'email': 'admin@batkitty.id',
      'password': 'admin123',
      'created_at': '2026-08-01T08:00:00Z',
    },
    {
      'id': 2,
      'name': 'Kasir Utama',
      'email': 'kasir@batkitty.id',
      'password': 'kasir123',
      'created_at': '2026-08-10T09:00:00Z',
    },
  ],
  'menus': [
    {'id': 1, 'name': 'Steak + Mashed Potato', 'base_price': 30000, 'version': 'V.1', 'category': 'regular', 'is_active': true},
    {'id': 2, 'name': 'Steak + Mashed Potato + Sayur', 'base_price': 35000, 'version': 'V.1', 'category': 'regular', 'is_active': true},
    {'id': 3, 'name': 'Dimsum Goreng (10k/4pcs)', 'base_price': 10000, 'version': 'V.1', 'category': 'snack_box', 'is_active': true},
    {'id': 4, 'name': 'Dimsum Goreng (3k/pcs)', 'base_price': 3000, 'version': 'V.1', 'category': 'snack_box', 'is_active': true},
    {'id': 5, 'name': 'Udang Keju (3pcs)', 'base_price': 15000, 'version': 'V.1', 'category': 'snack_box', 'is_active': true},
    {'id': 6, 'name': 'Cheesy Melt Burger', 'base_price': 15000, 'version': 'V.1', 'category': 'regular', 'is_active': true},
  ],
  'expenses': [
    {'id': 1, 'title': 'Belanja Superindo', 'amount': 26000, 'date': '2026-08-31'},
  ],
  'vouchers': [
    {
      'id': 1,
      'customer_id': 1,
      'order_id_applied': 1,
      'discount_amount': 5000,
      'keterangan_diskon': 'Pelanggan Pertama',
      'is_redeemed': true,
    },
    {
      'id': 2,
      'customer_id': 5,
      'order_id_applied': null,
      'discount_amount': 2000,
      'keterangan_diskon': 'Promo Member',
      'is_redeemed': false,
    },
  ],
  'customers': [
    {
      'id': 1,
      'name': 'Fiona',
      'phone': '082327299404',
      'created_at': '2026-08-16T09:15:00Z',
      'orders': [
        {
          'id': 1,
          'tanggal_order': '2026-08-16',
          'tanggal_pengambilan': '2026-08-18',
          'total_price': 25000,
          'delivery_fee': 0,
          'delivery_type': 'Pickup',
          'delivery_address': null,
          'status_bayar': 'Lunas',
          'status_masak': 'Selesai',
          'items': [
            {'menu_name': 'Steak + Mashed Potato', 'quantity': 1, 'unit_price': 30000, 'custom_notes': null}
          ],
          'review': 'enaak',
        }
      ]
    },
    {
      'id': 2,
      'name': 'Shinta',
      'phone': '085162585792',
      'created_at': '2026-08-22T11:20:00Z',
      'orders': [
        {
          'id': 2,
          'tanggal_order': '2026-08-22',
          'tanggal_pengambilan': '2026-08-24',
          'total_price': 35000,
          'delivery_fee': 0,
          'delivery_type': 'Pickup',
          'delivery_address': null,
          'status_bayar': 'Lunas',
          'status_masak': 'Selesai',
          'items': [
            {'menu_name': 'Steak + Mashed Potato + Sayur', 'quantity': 1, 'unit_price': 35000, 'custom_notes': null}
          ],
          'review': 'enaakkkk, cm yg mashed potato agak kepedesan.',
        }
      ]
    },
    {
      'id': 3,
      'name': 'Chelsea',
      'phone': '08973189288',
      'created_at': '2026-08-24T13:40:00Z',
      'orders': [
        {
          'id': 3,
          'tanggal_order': '2026-08-24',
          'tanggal_pengambilan': '2026-08-24',
          'total_price': 25000,
          'delivery_fee': 5000,
          'delivery_type': 'Delivery',
          'delivery_address': 'Puri',
          'status_bayar': 'Lunas',
          'status_masak': 'Selesai',
          'items': [
            {'menu_name': 'Dimsum Goreng (10k/4pcs)', 'quantity': 2, 'unit_price': 10000, 'custom_notes': 'tambahan saus'}
          ],
          'review': null,
        }
      ]
    },
    {
      'id': 4,
      'name': 'Charlene',
      'phone': '081556677889',
      'created_at': '2026-08-26T07:12:00Z',
      'orders': [
        {
          'id': 4,
          'tanggal_order': '2026-08-26',
          'tanggal_pengambilan': '2026-08-28',
          'total_price': 36000,
          'delivery_fee': 5000,
          'delivery_type': 'Delivery',
          'delivery_address': 'Jl. Prof. Sudharto No. 10',
          'status_bayar': 'Lunas',
          'status_masak': 'Selesai',
          'items': [
            {'menu_name': 'Dimsum Goreng (3k/pcs)', 'quantity': 12, 'unit_price': 3000, 'custom_notes': null}
          ],
          'review': null,
        },
        {
          'id': 6,
          'tanggal_order': '2026-08-28',
          'tanggal_pengambilan': '2026-08-30',
          'total_price': 90000,
          'delivery_fee': 5000,
          'delivery_type': 'Delivery',
          'delivery_address': 'Jl. Prof. Sudharto No. 10',
          'status_bayar': 'Lunas',
          'status_masak': 'Selesai',
          'items': [
            {'menu_name': 'Dimsum Goreng (3k/pcs)', 'quantity': 30, 'unit_price': 3000, 'custom_notes': null}
          ],
          'review': null,
        }
      ]
    },
    {
      'id': 5,
      'name': 'Egbert',
      'phone': '085713214558',
      'created_at': '2026-08-27T08:00:00Z',
      'orders': [
        {
          'id': 5,
          'tanggal_order': '2026-08-26',
          'tanggal_pengambilan': '2026-08-29',
          'total_price': 69000,
          'delivery_fee': 2000,
          'delivery_type': 'Delivery',
          'delivery_address': 'Setiabudi Heights',
          'status_bayar': 'Lunas',
          'status_masak': 'Selesai',
          'items': [
            {'menu_name': 'Dimsum Goreng (3k/pcs)', 'quantity': 23, 'unit_price': 3000, 'custom_notes': null}
          ],
          'review': null,
        }
      ]
    },
    {
      'id': 6,
      'name': 'Janice',
      'phone': '0895619811892',
      'created_at': '2026-08-28T09:00:00Z',
      'orders': [
        {
          'id': 7,
          'tanggal_order': '2026-08-28',
          'tanggal_pengambilan': '2026-09-04',
          'total_price': 30000,
          'delivery_fee': 5000,
          'delivery_type': 'Delivery',
          'delivery_address': 'Jl. Sirojudin No.45, Tembalang',
          'status_bayar': 'Lunas',
          'status_masak': 'Proses',
          'items': [
            {'menu_name': 'Udang Keju (3pcs)', 'quantity': 2, 'unit_price': 15000, 'custom_notes': null}
          ],
          'review': null,
        },
        {
          'id': 8,
          'tanggal_order': '2026-08-28',
          'tanggal_pengambilan': '2026-09-04',
          'total_price': 15000,
          'delivery_fee': 0,
          'delivery_type': 'Pickup',
          'delivery_address': null,
          'status_bayar': 'Lunas',
          'status_masak': 'Proses',
          'items': [
            {'menu_name': 'Cheesy Melt Burger', 'quantity': 1, 'unit_price': 15000, 'custom_notes': null}
          ],
          'review': null,
        }
      ]
    }
  ],
};