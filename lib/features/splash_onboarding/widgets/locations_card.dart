import 'package:flutter/material.dart';
import 'package:saved/constants/app_colors.dart';




class LocationsCard extends StatelessWidget {
  final String title;
  final String image;

  const LocationsCard({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 95,
          height: 95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
            boxShadow: [
              BoxShadow(color: AppColors.charcoal.withAlpha(64), blurRadius:5),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,fontStyle: FontStyle.normal,color: AppColors.mocha),
        ),
      ],
    );
  }
}
