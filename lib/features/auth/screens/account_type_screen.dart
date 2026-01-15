// lib/features/auth/screens/account_type_screen.dart
import 'package:flutter/material.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';


import 'widgets/account_type_card.dart';

class AccountTypePage extends StatelessWidget {
  const AccountTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.milk,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                spacing:8,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Image.asset('assets/images/logo.png', height:1, width: 200),
                  
                  const Text(
                    AppStrings.accountTypeTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, color: AppColors.charcoal, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,wordSpacing:1.2 ),
                  ),
                  const SizedBox(height:45),
                  // --- بطاقة المستأجر (Renter) ---
                  AccountTypeCard(
                    icon: Icons.key_outlined,
                    title: AppStrings.renterTitle,
                    subtitle: AppStrings.renterSubtitle,
                    onTap: () => Navigator.pushNamed(context, '/register', arguments: 'renter'),
                  ),
                  const SizedBox(height: 20),
                  // --- بطاقة المالك (Owner) ---
                  AccountTypeCard(
                    isPrimary: false,
                    icon: Icons.home_work_outlined,
                    title: AppStrings.ownerTitle,
                    subtitle: AppStrings.ownerSubtitle,
                    onTap: () => Navigator.pushNamed(context, '/register', arguments: 'owner'),
                  ),
                  const SizedBox(height:50),
                  // --- رابط تسجيل الدخول ---
                  GestureDetector(
                     onTap: () => Navigator.pushNamed(context, '/login'),
                     child:
                         RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize:18, color: AppColors.mocha, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                              children: [
                                TextSpan(text: AppStrings.alreadyHaveAccount),
                                TextSpan(
                                  text: AppStrings.login,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.charcoal,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                       
                     ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
