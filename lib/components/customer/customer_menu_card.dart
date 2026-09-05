import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class CustomerMenuCard extends StatelessWidget {
  final Map<String, dynamic> menu;
  final bool canOrder;
  final VoidCallback onOrder;

  const CustomerMenuCard({
    super.key,
    required this.menu,
    required this.canOrder,
    required this.onOrder,
  });

  String _formatRupiah(dynamic value) {
    final number = int.tryParse(value.toString()) ?? 0;
    final formatted = number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final int menuId = (menu['id'] as num?)?.toInt() ?? 0;
    final int price = (menu['base_price'] as num?)?.toInt() ?? 0;
    final String image = menu['image_url']?.toString() ?? '';

    final bool isPopular = menuId == 1 || menuId == 3;

    return Container(
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BatKittyTheme.borderSubtle),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 55,
            child: Stack(
              fit: StackFit.expand,
              children: [
                image.isNotEmpty
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: BatKittyTheme.surfaceHighlight,
                          child: const Icon(
                            Icons.restaurant_rounded,
                            color: BatKittyTheme.textMuted,
                            size: 24,
                          ),
                        ),
                      )
                    : Container(
                        color: BatKittyTheme.surfaceHighlight,
                        child: const Icon(
                          Icons.restaurant_rounded,
                          color: BatKittyTheme.textMuted,
                          size: 24,
                        ),
                      ),

                if (isPopular)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.7),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: Colors.amber.withOpacity(.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 10),
                          SizedBox(width: 3),
                          Text(
                            'Popular',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            flex: 45,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        menu['name'] ?? 'Menu',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: BatKittyTheme.textMain,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Row(
                        children: [
                          Icon(Icons.restaurant_menu, size: 10, color: BatKittyTheme.textMuted),
                          SizedBox(width: 4),
                          Text(
                            'Freshly prepared',
                            style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 8.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _formatRupiah(price),
                        style: const TextStyle(
                          color: BatKittyTheme.hotPink,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Material(
                        color: canOrder ? BatKittyTheme.hotPink : BatKittyTheme.surfaceHighlight,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: canOrder ? onOrder : null,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            child: Icon(Icons.add_rounded, color: Colors.white, size: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}