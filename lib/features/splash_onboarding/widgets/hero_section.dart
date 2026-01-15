// lib/features/splash_onboarding/widgets/hero_section.dart
import 'package:flutter/material.dart';
import 'package:saved/constants/app_strings.dart';



class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return 
       Stack(
        alignment: Alignment.topCenter,
        children: [
          // --- الطبقة 1: الصورة الرئيسية ---
          Padding(
            padding: const EdgeInsets.only(top: 110.0),
            child: Container(
              height: 420,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/images/home1.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
      
          // --- الطبقة 2: الغلاف الرمادي الشفاف لتوضيح النص ---
          Padding(
            padding: const EdgeInsets.only(top: 110),
            child: Container(
              height: 420,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5), // غلاف أغمق وأكثر وضوحاً
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
      
          // --- الطبقة 3: النصوص داخل الصورة ---
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            height: 420,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // العنوان
                const Text(
                  AppStrings.onboardingTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(2, 2),
                        blurRadius:20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 90),
                // النص الفرعي
                SizedBox(
      
                  width:270,
                  child: Text(
                    AppStrings.onboardingSub,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha:0.99),
                      fontSize: 17,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(1, 1),
                          blurRadius:20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      
          // --- الطبقة 4: الشعار في الأعلى ---
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Image.asset(
              "assets/images/logo.png",
              width: 160,
            ),
          ),
        ],
      
    );
  }
}
