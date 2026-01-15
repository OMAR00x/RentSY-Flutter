import 'package:flutter/material.dart';
import 'package:saved/features/splash_onboarding/widgets/locations_card.dart';



class LocationsList extends StatelessWidget {
  const LocationsList({super.key});

  // 🔥 قائمة الوجهات — عدّل عليها وقت ما بدك!
  final List<Map<String, String>> destinations = const [
    {"title": "Malki", "image": "assets/images/home2.jpg"},
    {"title": "ALJameliah", "image": "assets/images/home3.jpg"},
    {"title": "Bloudan ", "image": "assets/images/home4.jpg"},
    {"title": "saboura", "image": "assets/images/home5.jpg"},
    {"title": "Homs", "image": "assets/images/home6.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final item = destinations[index];

          return Row(
            children: [
              LocationsCard(title: item["title"]!, image: item["image"]!),
              const SizedBox(width: 12),
            ],
          );
        },
      ),
    );
  }
}
