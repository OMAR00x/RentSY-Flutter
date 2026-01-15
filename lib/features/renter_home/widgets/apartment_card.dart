import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/constants/api_constants.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/domain/models/apartment_model.dart';
import 'package:saved/core/widgets/loading_widget.dart';
import 'package:saved/features/renter_home/cubit/favorite_cubit.dart';
import 'package:saved/features/renter_home/cubit/favorite_state.dart';

class ApartmentCard extends StatelessWidget {
  final ApartmentModel apartment;
  final VoidCallback? onTap;

  const ApartmentCard({
    super.key,
    required this.apartment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: AppColors.oat.withValues(alpha:0.4),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  child: CachedNetworkImage(
                    imageUrl: getFullImageUrl(apartment.mainImageUrl!),
                    height: 210,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const SizedBox(height: 210, child: LoadingWidget()),
                    errorWidget: (_, __, ___) => Container(
                      height: 210,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  // ✨ استخدم BlocBuilder هنا عشان الأيقونة تتحدث فوراً
                  child: BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, state) {
                      bool isCurrentlyFavorite = apartment.isFavorite; // الحالة الافتراضية
                      // لو الكيوبت بيحمل قائمة مفضلة، بنتحقق من وجود الشقة فيها
                      state.whenOrNull(
                        loaded: (favorites) {
                          isCurrentlyFavorite = favorites.any((fav) => fav.id == apartment.id);
                        },
                      );
                      return GestureDetector(
                        onTap: () {
                          context.read<FavoriteCubit>().toggleFavorite(apartment);
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: isCurrentlyFavorite ? Colors.red[900] : Colors.grey, // ✨ هنا التغيير: بدون لون (رمادي) أو أحمر
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apartment.title,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    apartment.address,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '\$${apartment.price}',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.charcoal,
                        ),
                      ),
                      Text(
                        AppStrings.perNight,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.grey.shade600,
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
    );
  }
}
