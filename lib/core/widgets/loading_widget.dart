// lib/core/widgets/loading_widget.dart
import 'package:flutter/material.dart';
import 'package:saved/constants/app_colors.dart';



class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.taupe,
        strokeWidth: 3,
      ),
    );
  }
}
