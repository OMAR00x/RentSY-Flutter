import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/constants/api_constants.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/domain/models/apartment_model.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/core/widgets/loading_widget.dart';
import 'package:saved/features/renter_home/cubit/favorite_cubit.dart';
import 'package:saved/features/renter_home/cubit/favorite_state.dart';

class RenterApartmentDetailsScreen extends StatelessWidget {
  final ApartmentModel apartment;
  const RenterApartmentDetailsScreen({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    const bgColor = AppColors.oat;
    const primaryText = AppColors.charcoal;
    const secondaryText = AppColors.mocha;
    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.taupe,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: PageView.builder(
                itemCount: apartment.images.length,
                itemBuilder: (_, index) {
                  return CachedNetworkImage(
                    imageUrl: getFullImageUrl(apartment.images[index].url),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const LoadingWidget(),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
                  );
                },
              ),
            ),
            actions: [
              BlocBuilder<FavoriteCubit, FavoriteState>(
                builder: (context, state) {
                  bool isCurrentlyFavorite = apartment.isFavorite; // الحالة الافتراضية
                  state.whenOrNull(
                    loaded: (favorites) {
                      isCurrentlyFavorite = favorites.any((fav) => fav.id == apartment.id);
                    },
                  );

                  return IconButton(
                    icon: Icon(
                      isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isCurrentlyFavorite ? Colors.red[900] : Colors.white, // ✨ هنا التغيير: أبيض (بدون لون) أو أحمر
                      size: 28,
                    ),
                    onPressed: () {
                      context.read<FavoriteCubit>().toggleFavorite(apartment);
                    },
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          apartment.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${apartment.price.toStringAsFixed(2)} / ${apartment.priceType}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    apartment.address,
                    style: TextStyle(fontSize: 15, color: secondaryText),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.taupe, thickness: 0.5),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.aboutThisPlace,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    apartment.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: secondaryText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.taupe, thickness: 0.5),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.taupe.withValues(alpha:0.3),
                        backgroundImage: apartment.owner.avatar != null
                            ? CachedNetworkImageProvider(
                                getFullImageUrl(apartment.owner.avatar!.url),
                              )
                            : null,
                        child: apartment.owner.avatar == null
                            ? const Icon(
                                Icons.person,
                                size: 30,
                                color: AppColors.charcoal,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.hostedBy,
                            style: TextStyle(
                              fontSize: 14,
                              color: secondaryText,
                            ),
                          ),
                          Text(
                            '${apartment.owner.firstName} ${apartment.owner.lastName}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryText,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.chat,
                            arguments: {
                              'apartmentId': apartment.id,
                              'otherUserId': apartment.owner.id,
                              'otherUserName': '${apartment.owner.firstName} ${apartment.owner.lastName}',
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.charcoal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Chat"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.charcoal,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRouter.bookingRequest,
              arguments: apartment,
            );
          },
          child: const Text(
            AppStrings.bookNow,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
