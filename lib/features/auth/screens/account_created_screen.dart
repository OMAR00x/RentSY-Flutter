import 'package:flutter/material.dart';
import 'package:saved/constants/app_colors.dart';




class AccountCreatedSuccessfully extends StatelessWidget {
  const AccountCreatedSuccessfully({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.milk,
      // تم إزالة الـ AppBar لجعل التصميم أنظف
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            // توسيط كل العناصر في الصفحة
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // مساحة فارغة في الأعلى لدفع المحتوى للأسفل
              const Spacer(flex: 2),

              // أيقونة علامة الصح
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.taupe, // استخدام لون متناسق
                size: 100,
              ),
              const SizedBox(height: 24),

              // عنوان "Account Created"
              const Text(
                'Account Created Successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 16),

              // النص التوضيحي
              const Text(
                'Your account is now pending review. You will be notified once an administrator has approved it.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.mocha,
                  height: 1.5, // زيادة التباعد بين السطور لسهولة القراءة
                ),
              ),
              
              // مساحة فارغة لدفع الزر للأسفل
              const Spacer(flex: 3),

              // زر "العودة لتسجيل الدخول"
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.charcoal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // استخدام pushNamedAndRemoveUntil لإزالة كل الصفحات السابقة
                  // ومنع المستخدم من العودة لصفحة إنشاء الحساب
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (Route<dynamic> route) => false, // هذا يزيل كل ما قبله
                  );
                },
                child: const Text(
                  'Back to Login',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
