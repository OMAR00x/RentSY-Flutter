import 'package:flutter/material.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';



class BottomButton extends StatelessWidget {
  const BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 10,
        shadowColor: AppColors.mocha,
        overlayColor: AppColors.taupe,
        backgroundColor: AppColors.taupe,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/account-type');
      },
      child: const Text(
        AppStrings.getStarted,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,fontStyle: FontStyle.italic),
      ),
    );

  }
}
