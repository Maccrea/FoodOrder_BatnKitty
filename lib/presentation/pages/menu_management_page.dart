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
  String selectedVersionFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _menuList = List<Map<String, dynamic>>.from(appSeed['menus'] ?? []);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                width: 420,
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
                        activeThumbColor: BatKittyTheme.hotPink,
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
    final availableVersions = ['All', ..._menuList.map((m) => m['version']?.toString() ?? 'V.1').toSet()];

    // Filter gabungan (Pencarian nama + Kategori + Versi)
    final filteredMenus = _menuList.where((menu) {
      final nameMatches = menu['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      final categoryMatches = selectedCategoryFilter == 'All' || menu['category'] == selectedCategoryFilter;
      final versionMatches = selectedVersionFilter == 'All' || menu['version'] == selectedVersionFilter;
      return nameMatches && categoryMatches && versionMatches;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Utama
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Menu Management & Catalog', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 24, fontWeight: FontWeight.w900)),
                  SizedBox(height: 4),
                  Text('Kelola daftar menu, varian versi, kategori, dan harga dasar secara terpusat', style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 12.5)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BatKittyTheme.hotPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showMenuDialog(),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Tambah Menu Baru', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Control Bar Modern: Search + Filter Versi & Kategori
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: BatKittyTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BatKittyTheme.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris Pencarian & Dropdown Versi
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => searchQuery = val),
                        style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Cari nama menu...',
                          hintStyle: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 12),
                          prefixIcon: const Icon(Icons.search_rounded, color: BatKittyTheme.textSubtle, size: 20),
                          filled: true,
                          fillColor: BatKittyTheme.surfaceElevated,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: BatKittyTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: BatKittyTheme.borderSubtle),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedVersionFilter,
                            dropdownColor: BatKittyTheme.surfaceDark,
                            style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12, fontWeight: FontWeight.w600),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: BatKittyTheme.textSubtle),
                            items: availableVersions.map((v) {
                              return DropdownMenuItem(value: v, child: Text(v == 'All' ? 'Semua Versi (All)' : 'Versi $v'));
                            }).toList(),
                            onChanged: (val) => setState(() => selectedVersionFilter = val ?? 'All'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: BatKittyTheme.borderSubtle),
                const SizedBox(height: 16),
                
                // Baris Pilihan Kategori (Chips)
                Row(
                  children: [
                    const Text('Kategori:', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['All', 'regular', 'snack_box', 'custom', 'diet_package'].map((category) {
                          bool isSelected = selectedCategoryFilter == category;
                          String labelName = category == 'All' ? 'Semua Kategori' : category.replaceAll('_', ' ').toUpperCase();
                          return ChoiceChip(
                            label: Text(labelName, style: TextStyle(color: isSelected ? Colors.white : BatKittyTheme.textSubtle, fontSize: 10.5, fontWeight: FontWeight.bold)),
                            selected: isSelected,
                            selectedColor: BatKittyTheme.hotPink,
                            backgroundColor: BatKittyTheme.surfaceElevated,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: isSelected ? BatKittyTheme.hotPink : BatKittyTheme.borderSubtle)),
                            onSelected: (selected) => setState(() => selectedCategoryFilter = category),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tabel Katalog Menu Profesional
          Container(
            decoration: BoxDecoration(
              color: BatKittyTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BatKittyTheme.borderSubtle),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
                    padding: const EdgeInsets.all(50),
                    alignment: Alignment.center,
                    child: const Text('Tidak ada menu yang sesuai dengan filter pencarian.', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 12)),
                  )
                else
                  ...List.generate(filteredMenus.length, (index) {
                    final menu = filteredMenus[index];
                    final bool isActive = menu['is_active'] ?? true;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: BatKittyTheme.borderSubtle)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(menu['name'], style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(menu['category'].toString().toUpperCase(), style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 11)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: BatKittyTheme.pinkGlow.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: BatKittyTheme.pinkGlow.withOpacity(0.3)),
                                ),
                                child: Text(menu['version'], style: const TextStyle(color: BatKittyTheme.pinkGlow, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(formatRupiah((menu['base_price'] as num).toInt()), style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.w700)),
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
                                  style: TextStyle(color: isActive ? Colors.greenAccent : Colors.redAccent, fontSize: 9.5, fontWeight: FontWeight.bold),
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