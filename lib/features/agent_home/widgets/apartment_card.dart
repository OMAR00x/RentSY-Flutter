import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saved/constants/api_constants.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/core/domain/models/apartment_model.dart';
import 'package:saved/core/widgets/loading_widget.dart';


class ApartmentCard extends StatelessWidget {
  final ApartmentModel apartment;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ApartmentCard({
    super.key,
    required this.apartment,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFFF0EAE2);
    const primaryText = AppColors.charcoal;
    const secondaryText = AppColors.taupe;
    const accentColor = AppColors.mocha;

    final imageHeight = (MediaQuery.of(context).size.height * 0.24).clamp(140.0, 220.0);

    return Stack(
      children: [
        Material(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: getFullImageUrl(apartment.mainImageUrl ?? ''),
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox(height: imageHeight, child: const LoadingWidget()),
                    errorWidget: (context, url, error) => Container(
                      height: imageHeight,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        apartment.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: accentColor, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              apartment.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: secondaryText, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '\$${apartment.price.toStringAsFixed(2)}',
                                style: const TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                ' / ${apartment.priceType}',
                                style: const TextStyle(color: secondaryText, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          // ✨ عرض عدد المفضلة (Like Count) مثل الصورة
                          // بنعرضه بس لو favoritesCount كان موجود وأكبر من 0
                          if (apartment.favoritesCount != null && apartment.favoritesCount! > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha:0.1),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.favorite, color: Colors.red[900], size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${apartment.favoritesCount}',
                                    style: const TextStyle(
                                      color: primaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // زر الحذف في الزاوية
        if (onDelete != null)
          Positioned(
            top: 14,
            left: 14,
            child: Material(
              color: Colors.black.withValues(alpha:0.5),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onDelete,
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(Icons.delete_outline, color: Colors.white, size: 22),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
