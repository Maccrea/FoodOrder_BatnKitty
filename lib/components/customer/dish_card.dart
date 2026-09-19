import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/theme.dart';
import '../../../core/utils/formatters.dart';

class DishCard extends StatefulWidget {
  final Map<String, dynamic> menu;
  final String fallbackImage;
  final VoidCallback? onAddPressed;

  const DishCard({
    super.key,
    required this.menu,
    required this.fallbackImage,
    this.onAddPressed,
  });

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> {
  bool _isPressed = false;

  static const Color cardColor = Color(0xFF14161C);
  static const Color imagePlaceholder = Color(0xFF1C1F27);
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF8C919C);

  int _number(dynamic value) {
    if (value is num) return value.toInt();

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;

    final stock = _number(
      menu['stok'] ?? menu['stock'],
    );

    final price = _number(menu['price'] ?? menu['base_price']);

    final name = menu['name']?.toString().trim().isNotEmpty == true
        ? menu['name'].toString()
        : 'Porsi Batch';

    final imageUrl = _resolveImage(menu);

    final isSoldOut = stock <= 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        final double titleSize = cardWidth < 170 ? 12.5 : 14.0;

        return Semantics(
          button: !isSoldOut,
          label: isSoldOut
              ? '$name, menu habis'
              : '$name, ${formatRupiah(price)}, sisa $stock',
          child: AnimatedScale(
            scale: _isPressed ? 0.975 : 1,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOut,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isSoldOut
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        widget.onAddPressed?.call();
                      },
                onHighlightChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _isPressed = value;
                    });
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(.065),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.16),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      Expanded(
                        flex: 13,
                        child: _ImageSection(
                          imageUrl: imageUrl,
                          stock: stock,
                          isSoldOut: isSoldOut,
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            14,
                            12,
                            12,
                            12,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isSoldOut
                                      ? textSecondary
                                      : textPrimary,
                                  fontSize: titleSize,
                                  height: 1.18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -.25,
                                ),
                              ),

                              const Spacer(),

                              Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'MULAI DARI',
                                          style: TextStyle(
                                            color: textSecondary,
                                            fontSize: 7,
                                            fontWeight:
                                                FontWeight.w800,
                                            letterSpacing: .8,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          formatRupiah(price),
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isSoldOut
                                                ? textSecondary
                                                : BatKittyTheme.hotPink,
                                            fontSize:
                                                cardWidth < 170
                                                    ? 12
                                                    : 13.5,
                                            fontWeight:
                                                FontWeight.w900,
                                            letterSpacing: -.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (!isSoldOut)
                                    _AddButton(
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        widget.onAddPressed?.call();
                                      },
                                    )
                                  else
                                    _SoldOutLabel(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _resolveImage(
    Map<String, dynamic> menu,
  ) {
    final imageUrl = menu['image_url']?.toString().trim();

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return imageUrl;
    }

    final image = menu['image']?.toString().trim();

    if (image != null && image.isNotEmpty) {
      return image;
    }

    return widget.fallbackImage;
  }
}


class _ImageSection extends StatelessWidget {
  final String imageUrl;
  final int stock;
  final bool isSoldOut;

  const _ImageSection({
    required this.imageUrl,
    required this.stock,
    required this.isSoldOut,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          loadingBuilder: (
            context,
            child,
            loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            return Container(
              color: const Color(0xFF1C1F27),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress
                                .expectedTotalBytes !=
                            null
                        ? loadingProgress
                                .cumulativeBytesLoaded /
                            loadingProgress
                                .expectedTotalBytes!
                        : null,
                    color: BatKittyTheme.hotPink,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color: const Color(0xFF1C1F27),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_rounded,
                    color: Colors.white.withOpacity(.18),
                    size: 30,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'No image',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.25),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.10),
                  Colors.transparent,
                  Colors.black.withOpacity(.42),
                ],
                stops: const [
                  0,
                  .55,
                  1,
                ],
              ),
            ),
          ),
        ),

        if (isSoldOut)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(.58),
            ),
          ),

        Positioned(
          top: 10,
          left: 10,
          child: _StockBadge(
            stock: stock,
            isSoldOut: isSoldOut,
          ),
        ),

        if (isSoldOut)
          const Center(
            child: _SoldOutIcon(),
          ),
      ],
    );
  }
}

class _StockBadge extends StatelessWidget {
  final int stock;
  final bool isSoldOut;

  const _StockBadge({
    required this.stock,
    required this.isSoldOut,
  });

  @override
  Widget build(BuildContext context) {
    final bool lowStock = stock > 0 && stock <= 3;

    final Color badgeColor = isSoldOut
        ? Colors.black.withOpacity(.72)
        : lowStock
            ? BatKittyTheme.hotPink.withOpacity(.92)
            : Colors.black.withOpacity(.62);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: Colors.white.withOpacity(.10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSoldOut
                ? Icons.remove_shopping_cart_rounded
                : lowStock
                    ? Icons.local_fire_department_rounded
                    : Icons.inventory_2_outlined,
            color: Colors.white,
            size: 11,
          ),
          const SizedBox(width: 5),
          Text(
            isSoldOut
                ? 'HABIS'
                : lowStock
                    ? 'SISA $stock'
                    : '$stock PORSI',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: .4,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BatKittyTheme.hotPink,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(11),
        child: const SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 21,
          ),
        ),
      ),
    );
  }
}

class _SoldOutIcon extends StatelessWidget {
  const _SoldOutIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.48),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(.12),
        ),
      ),
      child: const Icon(
        Icons.no_food_rounded,
        color: Colors.white70,
        size: 22,
      ),
    );
  }
}

class _SoldOutLabel extends StatelessWidget {
  const _SoldOutLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.045),
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Text(
        'HABIS',
        style: TextStyle(
          color: Color(0xFF7E838D),
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: .6,
        ),
      ),
    );
  }
}