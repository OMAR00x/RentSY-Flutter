import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/core/widgets/loading_widget.dart'; // ✨ 1. استيراد الويدجت الخاصة بك
import 'package:saved/features/agent_home/cubit/my_apartments_cubit.dart';
import 'package:saved/features/agent_home/cubit/my_apartments_state.dart';
import '../widgets/apartment_card.dart';

class AgentHomeScreen extends StatefulWidget {
  const AgentHomeScreen({super.key});

  @override
  State<AgentHomeScreen> createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyApartmentsCubit>().fetchMyApartments();
    });
  }

  Future<void> _navigateAndRefresh() async {
    final result = await Navigator.pushNamed(context, AppRouter.addApartment);
    if (result == true && mounted) {
      context.read<MyApartmentsCubit>().fetchMyApartments();
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryText = AppColors.charcoal;
    const secondaryText = AppColors.taupe;
    const accentColor = AppColors.mocha;

    return Scaffold(
      backgroundColor: AppColors.oat,
      appBar: AppBar(
        backgroundColor: AppColors.oat,
        elevation: 0,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.agentHomeTitle, style: TextStyle(color: primaryText, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 3),
            Text(AppStrings.agentHomeSubtitle, style: TextStyle(color: secondaryText, fontSize: 14)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: accentColor,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _navigateAndRefresh,
                child: const SizedBox(width: 42, height: 42, child: Icon(Icons.add, color: Colors.white)),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.notifications);
            },
            icon: const Icon(Icons.notifications_none),
            color: accentColor,
            iconSize: 28,
          ),
        ],
      ),
      body: BlocBuilder<MyApartmentsCubit, MyApartmentsState>(
        builder: (context, state) {
          return state.when(
            // ✨ 2. استخدام الويدجت الخاصة بك هنا
            initial: () => const LoadingWidget(),
            loading: () => const LoadingWidget(),
            error: (message) => _buildErrorState(context, message),
            empty: () => _buildEmptyState(context),
            success: (apartments) {
              return RefreshIndicator(
                color: accentColor,
                onRefresh: () async {
                  context.read<MyApartmentsCubit>().fetchMyApartments();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: apartments.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final apartment = apartments[index];
                            return ApartmentCard(
                              apartment: apartment,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouter.agentApartmentDetails,
                                  arguments: apartment,
                                );
                              },
                              onDelete: () => _showDeleteConfirmation(context, apartment.id, apartment.title),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.oat,
        selectedItemColor: primaryText,
        unselectedItemColor: secondaryText,
        // ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨
        // ✨            الحل النهائي هنا            ✨
        // ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨
        onTap: (index) {
          // إذا ضغط المستخدم على "Home" (index 0)، لا تفعل شيئاً لأننا هنا بالفعل
          if (index == 0) return;

          // إذا ضغط على "Requests" (index 1)، انتقل إلى صفحة الطلبات
          if (index == 1) {
            Navigator.pushNamed(context, AppRouter.bookingRequests);
          }

          // Chat - يفتح صفحة المحادثات
          if (index == 2) {
            Navigator.pushNamed(context, AppRouter.conversations);
          }

          // ✨ إذا ضغط على "Profile" (index 3)، انتقل إلى شاشة البروفايل
          if (index == 3) {
            Navigator.pushNamed(context, AppRouter.profile);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: "Requests"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ... (باقي الدوال المساعدة كما هي بدون تغيير)
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
            const SizedBox(height: 16),
            const Text('Something Went Wrong', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.read<MyApartmentsCubit>().fetchMyApartments(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.mocha),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.house_siding_rounded, size: 80, color: AppColors.taupe),
          const SizedBox(height: 16),
          const Text('No Apartments Yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Click the "+" button in the top right to add your first apartment and start renting.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.taupe),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int apartmentId, String title) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "$title"? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<MyApartmentsCubit>().deleteApartment(apartmentId);
              },
            ),
          ],
        );
      },
    );
  }
}
