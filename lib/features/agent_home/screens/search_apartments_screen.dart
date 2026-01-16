import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/features/agent_home/cubit/my_apartments_cubit.dart';
import 'package:saved/features/agent_home/cubit/my_apartments_state.dart';
import 'package:saved/core/widgets/loading_widget.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/features/agent_home/widgets/apartment_card.dart';

class SearchApartmentsScreen extends StatefulWidget {
  const SearchApartmentsScreen({super.key});

  @override
  State<SearchApartmentsScreen> createState() => _SearchApartmentsScreenState();
}

class _SearchApartmentsScreenState extends State<SearchApartmentsScreen> {
  final TextEditingController _controller = TextEditingController();

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    context.read<MyApartmentsCubit>().searchApartments(query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oat,
      appBar: AppBar(
        backgroundColor: AppColors.oat,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.charcoal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                cursorColor: AppColors.taupe,
                style: const TextStyle(color: AppColors.charcoal, fontSize: 16),
                decoration: InputDecoration(
                  hintText: AppStrings.searchApartmentHint,
                  hintStyle: const TextStyle(color: AppColors.taupe),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: AppColors.taupe),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.taupe, size: 20),
                          onPressed: () {
                            _controller.clear();
                            setState(() {});
                            context.read<MyApartmentsCubit>().fetchMyApartments();
                          },
                        )
                      : null,
                ),
                onSubmitted: _performSearch,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.charcoal),
              onPressed: () => _performSearch(_controller.text),
            ),
          ],
        ),
      ),
      body: BlocBuilder<MyApartmentsCubit, MyApartmentsState>(
        builder: (context, state) {
          return state.when(
            initial: () => _buildEmptyState(),
            loading: () => const LoadingWidget(),
            error: (message) => Center(child: Text('Error: $message')),
            empty: () => const Center(
              child: Text(
                'No apartments found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            success: (apartments) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: apartments.length,
                itemBuilder: (_, i) {
                  final apartment = apartments[i];
                  return ApartmentCard(
                    apartment: apartment,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.agentApartmentDetails,
                        arguments: apartment,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.search, color: AppColors.taupe, size: 52),
            SizedBox(height: 16),
            Text(
              AppStrings.searchPlaceholder,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.taupe, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
