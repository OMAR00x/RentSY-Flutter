// lib/features/splash_onboarding/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/features/splash_onboarding/widgets/locations_list.dart';


import '../widgets/hero_section.dart';
import '../widgets/header_section.dart';
import '../widgets/bottom_button.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.milk,
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            spacing: 15,
            children: [
              HeroSection(),
              //SizedBox(height:20),
              HeaderSection(),
              //SizedBox(height: 15),
              LocationsList(),
              //SizedBox(height: ),
              BottomButton(),
              SizedBox(height:15),
            ],
          ),
        ),
      ),
    );
  }
}
