import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/core/widgets/loading_widget.dart'; // ✨ استيراد
import 'package:saved/features/renter_home/cubit/all_apartments_cubit.dart';
import 'package:saved/features/renter_home/cubit/all_apartments_state.dart';
import '../widgets/apartment_card.dart';
import '../widgets/home_header.dart';
import '../widgets/search_filter_section.dart';

class RenterHomeScreen extends StatefulWidget {
  const RenterHomeScreen({super.key});
  @override
  State<RenterHomeScreen> createState() => _RenterHomeScreenState();
}

class _RenterHomeScreenState extends State<RenterHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllApartmentsCubit>().fetchAllApartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            const HomeHeader(),
            const SizedBox(height: 20),
            const SearchFilterSection(),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<AllApartmentsCubit, AllApartmentsState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const LoadingWidget(), // ✨ استخدام
                    loading: () => const LoadingWidget(), // ✨ استخدام
                    error: (message) => Center(child: Text('Error: $message')),
                    empty: () => const Center(
                      child: Text(
                        'No apartments available right now.\nCheck back later!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                    success: (apartments) {
                      return RefreshIndicator(
                        onRefresh: () async {
                           context.read<AllApartmentsCubit>().fetchAllApartments();
                        },
                        child: ListView.builder(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
