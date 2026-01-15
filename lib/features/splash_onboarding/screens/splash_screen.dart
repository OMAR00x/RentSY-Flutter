import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import 'package:saved/constants/app_colors.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/features/auth/cubit/auth_cubit.dart';
import 'package:saved/features/auth/cubit/auth_state.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with TickerProviderStateMixin {
  // --- مدة الأنيميشن الرئيسي، يمكنك تعديلها ---
  static const Duration _mainDuration = Duration(milliseconds: 3000);
  static const Duration _pulseDuration = Duration(milliseconds: 400);
  static const double _logoSize = 320.0;
  static const Color _backgroundColor = AppColors.oat;

  late final AnimationController _mainController;
  late final AnimationController _pulseController;
  late final Animation<double> _translateAnim;
  late final Animation<double> _rotationAnim;
  late final Animation<double> _opacityAnim;
  late final Animation<double> _pulseScaleAnim;
  late double _startDy;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(vsync: this, duration: _mainDuration)..forward();
    _translateAnim = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut));
    _rotationAnim = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut));
    _opacityAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _mainController, curve: Curves.easeIn));
    _pulseController = AnimationController(vsync: this, duration: _pulseDuration);
    _pulseScaleAnim = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.15).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_pulseController);

    // --- ✨ 1. تعديل المنطق هنا ---
    // سنستمع إلى حالة الأنيميشن الرئيسي
    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.forward();
        // --- ✨ 2. بعد اكتمال الأنيميشن، نبدأ التحقق من المصادقة ---
        // نتأكد أن الواجهة ما زالت موجودة
        if (mounted) {
          context.read<AuthCubit>().checkAuthStatus();
        }
      }
    });

    // --- ❌ 3. حذف كود الانتقال التلقائي بعد 4 ثوانٍ ---
    // هذا الكود كان يتعارض مع BlocListener
    /* 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 4), () {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, "/onboarding");
      });
    });
    */
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // تأكد من أن context متاح قبل استخدامه
    if (MediaQuery.of(context).size.height > 0) {
      _startDy = MediaQuery.of(context).size.height / 2 + _logoSize;
    } else {
      // قيمة افتراضية في حال لم يكن الـ context جاهزاً بعد
      _startDy = 500.0; 
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- ✨ 4. BlocListener سيعمل الآن بشكل صحيح ---
    // سيستمع إلى الحالة التي ستأتي بعد انتهاء الأنيميشن ويقوم بالتوجيه
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.mapOrNull(
          authenticated: (authState) {
            final targetRoute = authState.user.role == 'owner'
                ? AppRouter.agentHome
                : AppRouter.renterHome;
            Navigator.pushReplacementNamed(context, targetRoute);
          },
          unauthenticated: (_) {
            Navigator.pushReplacementNamed(context, AppRouter.onboarding);
          },
          pendingApproval: (pendingState) {
            Navigator.pushReplacementNamed(context, AppRouter.login);
          },
          rejected: (rejectedState) {
            Navigator.pushReplacementNamed(context, AppRouter.login);
          },
          error: (_) {
            Navigator.pushReplacementNamed(context, AppRouter.login);
          },
        );
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_mainController, _pulseController]),
              builder: (context, child) {
                final dy = _startDy * _translateAnim.value;
                final scale = _pulseScaleAnim.value;
                return Opacity(
                  opacity: _opacityAnim.value,
                  child: Transform.translate(
                    offset: Offset(0, dy),
                    child: Transform.rotate(
                      angle: _rotationAnim.value,
                      child: Transform.scale(
                        scale: scale,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: Image.asset(
                'assets/images/logo.png', // تأكد من أن هذا المسار صحيح
                width: _logoSize,
                height: _logoSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: _logoSize,
                  height: _logoSize,
                  color: Colors.redAccent,
                  alignment: Alignment.center,
                  child: const Text(
                    'Logo missing in\nassets/images/logo.png',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.milk, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
