import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/features/notifications/cubit/notification_cubit.dart';


class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.tenantHello,
          style: GoogleFonts.lato(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.charcoal,
          ),
        ),
        Stack(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.oat,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.notifications);
                },
                icon: const Icon(
                  Icons.notifications_none,
                  color: AppColors.charcoal,
                ),
              ),
            ),
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                int unreadCount = 0;
                if (state is NotificationLoaded) {
                  unreadCount = state.notifications.where((n) => !n.isRead).length;
                }
                if (unreadCount == 0) return const SizedBox();
                return Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
