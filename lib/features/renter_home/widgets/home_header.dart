import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';


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
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.oat,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.charcoal,
            ),
          ),
        ),
      ],
    );
  }
}
