import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/features/renter_home/cubit/all_apartments_cubit.dart';
import 'package:saved/features/renter_home/cubit/all_apartments_state.dart';
import 'package:saved/features/renter_home/cubit/search_history_cubit.dart';
import 'package:saved/core/widgets/loading_widget.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/features/renter_home/widgets/apartment_card.dart';

class RenterSearchScreen extends StatefulWidget {
  const RenterSearchScreen({super.key});

  @override
  State<RenterSearchScreen> createState() => _RenterSearchScreenState();
}

class _RenterSearchScreenState extends State<RenterSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchHistoryCubit>().loadHistory();
    });
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    setState(() => _isSearching = true);
    context.read<AllApartmentsCubit>().searchApartments(query);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) context.read<SearchHistoryCubit>().loadHistory();
    });
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => _isSearching = false);
    context.read<AllApartmentsCubit>().fetchAllApartments();
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
                          icon: const Icon(Icons.close, color: AppColors.taupe, size: 20),
                          onPressed: _clearSearch,
                        )
                      : null,
                ),
                onChanged: (value) => setState(() {}),
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
      body: BlocBuilder<AllApartmentsCubit, AllApartmentsState>(
        builder: (context, state) {
          return state.when(
            initial: () => _buildSearchHistory(),
            loading: () => const LoadingWidget(),
            error: (message) => Center(child: Text('Error: $message')),
            empty: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No apartments found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _clearSearch,
                    child: const Text('Clear search'),
                  ),
                ],
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
                        AppRouter.renterApartmentDetails,
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

  Widget _buildSearchHistory() {
    return BlocBuilder<SearchHistoryCubit, List>(
      builder: (context, history) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (history.isEmpty)
                Expanded(
                  child: Center(
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
                ),
              if (history.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.charcoal,
                    ),
                  ),
                ),
              if (history.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.history, color: AppColors.taupe),
                          title: Text(item.query),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              context.read<SearchHistoryCubit>().deleteHistory(item.id);
                            },
                          ),
                          onTap: () {
                            _controller.text = item.query;
                            _performSearch(item.query);
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
