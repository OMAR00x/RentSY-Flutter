// lib/features/auth/screens/widgets/account_type_card.dart
import 'package:flutter/material.dart';
import 'package:saved/constants/app_colors.dart';




class AccountTypeCard extends StatelessWidget {
  final bool isPrimary;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AccountTypeCard({
    super.key,
    this.isPrimary = true,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isPrimary ? AppColors.oat : AppColors.mocha.withValues(alpha:0.98);
    final iconColor = isPrimary ? AppColors.taupe : AppColors.milk;
    final titleColor = AppColors.charcoal.withValues(alpha: 0.99);
    final subtitleColor =AppColors.charcoal.withValues(alpha:0.99);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        width:400,
        decoration: BoxDecoration(
          color:cardColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: AppColors.mocha.withValues(alpha:0.15),
              blurRadius:20,
              spreadRadius:7,
              offset: const Offset(4,3 ),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 20),
            Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: titleColor)),
            const SizedBox(height:5),
            Text(subtitle, style: TextStyle(fontSize: 16, color: subtitleColor)),
          ],
        ),
      ),
    );
  }
}
