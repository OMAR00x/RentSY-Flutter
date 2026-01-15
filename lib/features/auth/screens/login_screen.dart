import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/core/routing/app_router.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            _mobileController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor),
      );
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(
        fontSize: 13,
        color: AppColors.charcoal,
      ),
      hintStyle: TextStyle(
        color: AppColors.charcoal.withValues(alpha: 0.5),
      ),
      filled: true,
      fillColor: AppColors.taupe.withValues(alpha: 0.25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffixIcon,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.milk,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            authenticated: (user) {
              if (user.role == 'owner') {
                Navigator.pushReplacementNamed(
                    context, AppRouter.agentHome);
              } else {
                Navigator.pushReplacementNamed(
                    context, AppRouter.renterHome);
              }
            },
            pendingApproval: (message) =>
                _showSnackBar(message, Colors.orangeAccent),
            rejected: (message) =>
                _showSnackBar(message, Colors.red.shade800),
            error: (message) =>
                _showSnackBar(message, Colors.redAccent),
          );
        },
        builder: (context, state) {
          final isLoading =
              state.maybeWhen(loading: () => true, orElse: () => false);

          return SafeArea(
            child: IgnorePointer(
              ignoring: isLoading,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    
                    children: [
                      const SizedBox(height: 40),

                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.charcoal,
                          
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Welcome Back! Enter your information\nto get started',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.mocha,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height:50),

                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(
                          label: 'Mobile Number',
                          hint: 'Enter your mobile number',
                        ),
                        validator: (v) =>
                            v == null || v.length < 10
                                ? 'Enter a valid number'
                                : null,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        decoration: _inputDecoration(
                          label: 'Password',
                          hint: 'Enter your password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.charcoal,
                            ),
                            onPressed: () => setState(
                                () => _isObscure = !_isObscure),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.length < 8
                                ? 'Password is too short'
                                : null,
                      ),

                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forget your password?',
                            style: TextStyle(
                              color: AppColors.mocha,
                              fontSize:12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height:30),

                      SizedBox(
                        width:double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : _submitLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mocha.withValues(alpha: 0.89),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(18),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: AppColors.charcoal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.taupe,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, '/account-type'),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: AppColors.charcoal,
                                fontWeight: FontWeight.w800,
                                
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
