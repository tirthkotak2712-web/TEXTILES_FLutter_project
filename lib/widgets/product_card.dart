import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textiles/core/format.dart';
import 'package:textiles/models/product.dart';
import 'package:textiles/repositories/store_repository.dart';
import 'package:textiles/resources/app_styles.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showRating = false,
    this.showHeart = false,
  });

  final Product product;
  final VoidCallback? onTap;
  final bool showRating;
  final bool showHeart;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreRepository>();
    final wished = store.isWished(product.id);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.86,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ColoredBox(
                      color: const Color(0xFFF3F1EC),
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Center(child: Icon(Icons.checkroom_outlined, color: AppColors.muted)),
                      ),
                    ),
                  ),
                ),
                if (showHeart)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => store.toggleWishlist(product.id),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            wished ? Icons.favorite : Icons.favorite_border,
                            color: wished ? AppColors.danger : AppColors.ink,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                Format.inr(product.price),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              if (showRating) ...[
                const Spacer(),
                const Icon(Icons.star, color: AppColors.star, size: 16),
                Text(
                  ' ${product.rating.toStringAsFixed(1)}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class CatalogImage extends StatelessWidget {
  const CatalogImage({
    super.key,
    required this.image,
    this.radius = 12,
  });

  final String image;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColoredBox(
        color: const Color(0xFFF3F1EC),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, _, _) => const Center(child: Icon(Icons.checkroom_outlined, color: AppColors.muted)),
        ),
      ),
    );
  }
}
