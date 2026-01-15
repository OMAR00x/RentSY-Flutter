import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/core/widgets/loading_widget.dart';

import 'package:saved/features/renter_home/cubit/favorite_cubit.dart';
import 'package:saved/features/renter_home/cubit/favorite_state.dart';
import 'package:saved/features/renter_home/widgets/apartment_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // ✨ جلب الشقق المفضلة عند فتح الشاشة
    context.read<FavoriteCubit>().fetchFavoriteApartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.milk,
      appBar: AppBar(
        title: const Text(
          AppStrings.favorites,
          style: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.milk,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          return state.when(
            initial: () => const LoadingWidget(),
            loading: () => const LoadingWidget(),
            loaded: (apartments) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FavoriteCubit>().fetchFavoriteApartments();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(20.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: apartments.length,
                  itemBuilder: (_, i) {
                    final apartment = apartments[i];
                    return ApartmentCard(
                      apartment: apartment,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.renterApartmentDetails,
                          arguments: apartment,
                        );
                      },
                    );
                  },
                ),
              );
            },
            empty: () => Center(
              child: Text(
                AppStrings.noFavoritesYet,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            error: (message) => Center(
              child: Text(
                'Error: $message',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }
}
