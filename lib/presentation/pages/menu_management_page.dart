import 'package:flutter/material.dart';
import '../../core/constants/theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/local/app_seed.dart';

class MenuManagementPage extends StatefulWidget {
  const MenuManagementPage({super.key});

  @override
  State<MenuManagementPage> createState() => _MenuManagementPageState();
}

class _MenuManagementPageState extends State<MenuManagementPage> {
  late List<Map<String, dynamic>> _menuList;
  String selectedCategoryFilter = 'All';

  @override
  void initState() {
    super.initState();
    _menuList = List<Map<String, dynamic>>.from(appSeed['menus'] ?? []);
  }

  void _showMenuDialog({Map<String, dynamic>? menuToEdit, int? index}) {
    final nameController = TextEditingController(text: menuToEdit?['name'] ?? '');
    final priceController = TextEditingController(text: menuToEdit?['base_price']?.toString() ?? '');
    final versionController = TextEditingController(text: menuToEdit?['version'] ?? 'V.1');
    String selectedCategory = menuToEdit?['category'] ?? 'regular';
    bool isActive = menuToEdit?['is_active'] ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: BatKittyTheme.surfaceDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: BatKittyTheme.borderSubtle),
              ),
              title: Text(
                menuToEdit == null ? 'Tambah Menu Baru' : 'Edit Menu',
                style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 16, fontWeight: FontWeight.w900),
              ),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(controller: nameController, label: 'Nama Menu'),
                      const SizedBox(height: 14),
                      _buildTextField(controller: priceController, label: 'Harga Dasar (Rp)', keyboardType: TextInputType.number),
                      const SizedBox(height: 14),
                      _buildTextField(controller: versionController, label: 'Versi Menu (Contoh: V.1, V.2)'),
                      const SizedBox(height: 14),
                      const Text('Kategori Menu', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: BatKittyTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: BatKittyTheme.borderSubtle),
                        ),
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
                      const SizedBox(height: 14),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Status Menu Aktif', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 12, fontWeight: FontWeight.w700)),
                        value: isActive,
                        activeColor: BatKittyTheme.hotPink,
                        onChanged: (val) => setDialogState(() => isActive = val),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 12)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BatKittyTheme.hotPink,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                      setState(() {
                        final newMenuData = {
                          'id': menuToEdit != null ? menuToEdit['id'] : _menuList.length + 1,
                          'name': nameController.text.trim(),
                          'base_price': num.tryParse(priceController.text) ?? 0,
                          'version': versionController.text.trim().isEmpty ? 'V.1' : versionController.text.trim(),
                          'category': selectedCategory,
                          'is_active': isActive,
                        };

                        if (menuToEdit == null) {
                          _menuList.add(newMenuData);
                        } else {
                          _menuList[index!] = newMenuData;
                        }
                        
                        appSeed['menus'] = _menuList;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Menu berhasil disimpan!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
                      );
                    }
                  },
                  child: const Text('Simpan Menu', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12),
          decoration: InputDecoration(
            filled: true,
            fillColor: BatKittyTheme.surfaceElevated,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _confirmDeleteMenu(int index, String menuName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: BatKittyTheme.surfaceDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: BatKittyTheme.borderSubtle)),
          title: const Text('Hapus Menu', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 14, fontWeight: FontWeight.bold)),
          content: Text('Apakah Anda yakin ingin menghapus menu "$menuName"?', style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: BatKittyTheme.textSubtle)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                setState(() {
                  _menuList.removeAt(index);
                  appSeed['menus'] = _menuList;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu berhasil dihapus!'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
                );
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMenus = _menuList.where((menu) {
      if (selectedCategoryFilter == 'All') return true;
      return menu['category'] == selectedCategoryFilter;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Menu Management & Catalog', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 22, fontWeight: FontWeight.w900)),
                  SizedBox(height: 4),
                  Text('Atur daftar menu, kategori, versi, dan harga dasar secara real-time', style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 12)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BatKittyTheme.hotPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showMenuDialog(),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Tambah Menu Baru', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['All', 'regular', 'snack_box', 'custom', 'diet_package'].map((category) {
              bool isSelected = selectedCategoryFilter == category;
              return ChoiceChip(
                label: Text(category.toUpperCase(), style: TextStyle(color: isSelected ? Colors.white : BatKittyTheme.textSubtle, fontSize: 10, fontWeight: FontWeight.bold)),
                selected: isSelected,
                selectedColor: BatKittyTheme.hotPink,
                backgroundColor: BatKittyTheme.surfaceDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: BatKittyTheme.borderSubtle)),
                onSelected: (selected) => setState(() => selectedCategoryFilter = category),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              color: BatKittyTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BatKittyTheme.borderSubtle),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text('NAMA MENU', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5))),
                      Expanded(flex: 2, child: Text('KATEGORI', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5))),
                      Expanded(flex: 1, child: Text('VERSI', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5))),
                      Expanded(flex: 2, child: Text('HARGA DASAR', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5))),
                      Expanded(flex: 1, child: Text('STATUS', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5))),
                      Expanded(flex: 1, child: Text('AKSI', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5), textAlign: TextAlign.right)),
                    ],
                  ),
                ),
                const Divider(height: 1, color: BatKittyTheme.borderSubtle),
                if (filteredMenus.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(40),
                    alignment: Alignment.center,
                    child: const Text('Tidak ada menu dalam kategori ini.', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 12)),
                  )
                else
                  ...List.generate(filteredMenus.length, (index) {
                    final menu = filteredMenus[index];
                    final bool isActive = menu['is_active'] ?? true;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: BatKittyTheme.borderSubtle)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(menu['name'], style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 11.5, fontWeight: FontWeight.w700)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(menu['category'], style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 11)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(menu['version'], style: const TextStyle(color: BatKittyTheme.pinkGlow, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(formatRupiah((menu['base_price'] as num).toInt()), style: const TextStyle(color: Colors.greenAccent, fontSize: 11.5, fontWeight: FontWeight.w700)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: (isActive ? Colors.greenAccent : Colors.redAccent).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isActive ? 'Active' : 'Off',
                                  style: TextStyle(color: isActive ? Colors.greenAccent : Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, size: 16, color: BatKittyTheme.textMuted),
                                  tooltip: 'Edit Menu',
                                  onPressed: () => _showMenuDialog(menuToEdit: menu, index: index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_rounded, size: 16, color: Colors.redAccent),
                                  tooltip: 'Hapus Menu',
                                  onPressed: () => _confirmDeleteMenu(index, menu['name']),
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