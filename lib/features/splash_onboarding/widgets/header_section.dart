import 'package:flutter/material.dart';
import 'package:saved/constants/app_strings.dart';


class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      AppStrings.popularLocations,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
    );
  }
}
