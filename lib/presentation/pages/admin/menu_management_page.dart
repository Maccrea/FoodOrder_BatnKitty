import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/local/app_seed.dart';
import '../../../logic/admin/admin_bloc.dart';
import '../../../logic/admin/admin_state.dart';

class MenuManagementPage extends StatefulWidget {
  const MenuManagementPage({super.key});

  @override
  State<MenuManagementPage> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends State<MenuManagementPage> {
  late List<Map<String, dynamic>> _menuList;
  String selectedCategoryFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _menuList = (appSeed['menus'] as List?)
            ?.map((m) => {
                  ...Map<String, dynamic>.from(m),
                  'stock': m['stock'] ?? 20, 
                })
            .toList() ??
        [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleMenuStatus(int index) {
    setState(() {
      _menuList[index]['is_active'] = !(_menuList[index]['is_active'] ?? true);
      appSeed['menus'] = _menuList;
    });
  }

  void _updateStockDialog(int index) {
    final stockController = TextEditingController(text: '${_menuList[index]['stock'] ?? 0}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BatKittyTheme.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Atur Stok: ${_menuList[index]['name']}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Masukkan sisa porsi bahan baku hari ini:', style: TextStyle(color: Colors.white60, fontSize: 11.5)),
            const SizedBox(height: 10),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: BatKittyTheme.surfaceElevated,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                suffixText: 'Porsi',
                suffixStyle: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal', style: TextStyle(color: Colors.white60))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: BatKittyTheme.hotPink),
            onPressed: () {
              final newStock = int.tryParse(stockController.text) ?? 0;
              setState(() {
                _menuList[index]['stock'] = newStock;
                appSeed['menus'] = _menuList;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Simpan Stok', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showMenuDialog({Map<String, dynamic>? menuToEdit, int? index}) {
    final nameController = TextEditingController(text: menuToEdit?['name'] ?? '');
    final priceController = TextEditingController(text: menuToEdit?['base_price']?.toString() ?? '');
    final stockController = TextEditingController(text: '${menuToEdit?['stock'] ?? 20}');
    String selectedCategory = menuToEdit?['category'] ?? 'regular';
    bool isActive = menuToEdit?['is_active'] ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: BatKittyTheme.surfaceDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: BatKittyTheme.borderSubtle)),
              title: Text(
                menuToEdit == null ? 'Tambah Menu Baru' : 'Edit Menu & Stok',
                style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 16, fontWeight: FontWeight.w900),
              ),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(controller: nameController, label: 'Nama Menu'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(controller: priceController, label: 'Harga (Rp)', keyboardType: TextInputType.number)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildTextField(controller: stockController, label: 'Stok Hari Ini (Porsi)', keyboardType: TextInputType.number)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Kategori Menu', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: BatKittyTheme.surfaceElevated, borderRadius: BorderRadius.circular(10), border: Border.all(color: BatKittyTheme.borderSubtle)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            dropdownColor: BatKittyTheme.surfaceDark,
                            style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12),
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: 'regular', child: Text('Regular')),
                              DropdownMenuItem(value: 'snack_box', child: Text('Snack Box')),
                              DropdownMenuItem(value: 'custom', child: Text('Custom')),
                              DropdownMenuItem(value: 'diet_package', child: Text('Diet Package')),
                            ],
                            onChanged: (val) {
                              if (val != null) setDialogState(() => selectedCategory = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Status Menu Aktif (Bisa Dipesan)', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 12, fontWeight: FontWeight.w700)),
                        value: isActive,
                        activeThumbColor: BatKittyTheme.hotPink,
                        onChanged: (val) => setDialogState(() => isActive = val),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal', style: TextStyle(color: BatKittyTheme.textSubtle))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: BatKittyTheme.hotPink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                      setState(() {
                        final data = {
                          'id': menuToEdit != null ? menuToEdit['id'] : _menuList.length + 1,
                          'name': nameController.text.trim(),
                          'base_price': num.tryParse(priceController.text) ?? 0,
                          'stock': int.tryParse(stockController.text) ?? 0,
                          'version': 'V.1',
                          'category': selectedCategory,
                          'is_active': isActive,
                        };
                        if (menuToEdit == null) {
                          _menuList.add(data);
                        } else {
                          _menuList[index!] = data;
                        }
                        appSeed['menus'] = _menuList;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Simpan Menu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11, fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12),
          decoration: InputDecoration(
            filled: true,
            fillColor: BatKittyTheme.surfaceElevated,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _menuList.where((m) {
      final matchSearch = m['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      final matchCat = selectedCategoryFilter == 'All' || m['category'] == selectedCategoryFilter;
      return matchSearch && matchCat;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Katalog Menu & Manajemen Stok', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 22, fontWeight: FontWeight.w900)),
                  SizedBox(height: 4),
                  Text('Pantau sisa porsi bahan baku, harga dasar, serta status aktif/mati menu.', style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 12)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: BatKittyTheme.hotPink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () => _showMenuDialog(),
                icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                label: const Text('Tambah Menu', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => searchQuery = val),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Cari nama menu...',
                      hintStyle: const TextStyle(color: Colors.white30, fontSize: 11),
                      prefixIcon: const Icon(Icons.search, size: 16, color: Colors.white38),
                      filled: true,
                      fillColor: BatKittyTheme.surfaceDark,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Wrap(
                spacing: 8,
                children: ['All', 'regular', 'snack_box', 'custom'].map((cat) {
                  final isSel = selectedCategoryFilter == cat;
                  return ChoiceChip(
                    label: Text(cat == 'All' ? 'Semua Kategori' : cat.toUpperCase()),
                    selected: isSel,
                    selectedColor: BatKittyTheme.hotPink,
                    backgroundColor: BatKittyTheme.surfaceDark,
                    labelStyle: TextStyle(color: isSel ? Colors.white : Colors.white60, fontSize: 11, fontWeight: FontWeight.bold),
                    onSelected: (val) => setState(() => selectedCategoryFilter = cat),
                  );
                }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            decoration: BoxDecoration(
              color: BatKittyTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BatKittyTheme.borderSubtle),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      const Expanded(flex: 3, child: Text('NAMA MENU', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10, fontWeight: FontWeight.w800))),
                      const Expanded(flex: 2, child: Text('KATEGORI', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10, fontWeight: FontWeight.w800))),
                      const Expanded(flex: 2, child: Text('HARGA DASAR', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10, fontWeight: FontWeight.w800))),
                      const Expanded(flex: 2, child: Text('STOK TERSEDIA', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10, fontWeight: FontWeight.w800))),
                      const Expanded(flex: 2, child: Text('STATUS MENU', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10, fontWeight: FontWeight.w800))),
                      const Expanded(flex: 1, child: Text('AKSI', textAlign: TextAlign.right, style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10, fontWeight: FontWeight.w800))),
                    ],
                  ),
                ),
                const Divider(height: 1, color: BatKittyTheme.borderSubtle),
                ...List.generate(filtered.length, (idx) {
                  final menu = filtered[idx];
                  final bool active = menu['is_active'] ?? true;
                  final int stock = menu['stock'] ?? 0;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: BatKittyTheme.borderSubtle))),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(menu['name'], style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700))),
                        Expanded(flex: 2, child: Text(menu['category'].toString().toUpperCase(), style: const TextStyle(color: Colors.white60, fontSize: 11))),
                        Expanded(flex: 2, child: Text(formatRupiah((menu['base_price'] as num).toInt()), style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.w700))),
                        
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () => _updateStockDialog(idx),
                            borderRadius: BorderRadius.circular(6),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (stock <= 5 ? Colors.redAccent : Colors.tealAccent).withOpacity(.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text('$stock Porsi', style: TextStyle(color: stock <= 5 ? Colors.redAccent : Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.edit_note_rounded, size: 16, color: Colors.white38),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () => _toggleMenuStatus(idx),
                            child: Row(
                              children: [
                                Icon(active ? Icons.check_circle_rounded : Icons.cancel_rounded, color: active ? Colors.greenAccent : Colors.redAccent, size: 16),
                                const SizedBox(width: 6),
                                Text(active ? 'Aktif (Open)' : 'Off (Mati)', style: TextStyle(color: active ? Colors.greenAccent : Colors.redAccent, fontSize: 11, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_rounded, size: 16, color: Colors.white60),
                                onPressed: () => _showMenuDialog(menuToEdit: menu, index: idx),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}