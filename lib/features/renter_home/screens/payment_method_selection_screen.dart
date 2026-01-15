// lib/features/renter_home/screens/payment_method_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/core/domain/models/apartment_model.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/features/profile/cubit/profile_cubit.dart';
import 'package:saved/features/profile/cubit/profile_state.dart';

class PaymentMethodSelectionScreen extends StatefulWidget {
  final ApartmentModel apartment;
  final double totalAmount;

  const PaymentMethodSelectionScreen({super.key, required this.apartment, required this.totalAmount});

  @override
  State<PaymentMethodSelectionScreen> createState() => _PaymentMethodSelectionScreenState();
}

class _PaymentMethodSelectionScreenState extends State<PaymentMethodSelectionScreen> {
  String? _selectedPaymentMethod = 'wallet'; // Default to wallet
  double _walletBalance = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oat,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.charcoal),
        title: const Text(
          'Payment Method',
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          state.whenOrNull(
            loadSuccess: (user) {
              setState(() {
                _walletBalance = user.walletBalance;
                // Set default payment method if wallet is preferred and sufficient
                if (_selectedPaymentMethod == null || _selectedPaymentMethod == 'cash_on_arrival') {
                   _selectedPaymentMethod = (_walletBalance >= widget.totalAmount) ? 'wallet' : 'credit_card';
                }
              });
            },
            updateSuccess: (user) {
              setState(() {
                _walletBalance = user.walletBalance;
              });
            },
            loadFailure: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load wallet balance: $message'), backgroundColor: Colors.red),
              );
            },
          );
        },
        builder: (context, state) {
          final bool isLoadingProfile = state.maybeWhen(
            loadInProgress: () => true,
            orElse: () => false,
          );

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: _buildStepperIndicator(context, 1, 3),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Choose your payment method',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 30),
                _buildPaymentOption(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Wallet',
                  subtitle: 'Current balance: \$${_walletBalance.toStringAsFixed(2)}',
                  value: 'wallet',
                  isEnabled: _walletBalance >= widget.totalAmount,
                ),
                const SizedBox(height: 20),
                // Removed Cash on Arrival option
                _buildPaymentOption(
                  context,
                  icon: Icons.credit_card_outlined,
                  title: 'Electronic Payment',
                  subtitle: 'Pay securely with your card.',
                  value: 'credit_card',
                  isEnabled: true, // Always enabled for now
                ),
                const Spacer(),
                Text(
                  'Payment is processed securely.',
                  style: TextStyle(color: AppColors.taupe.withValues(alpha: 0.8), fontSize: 13),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _selectedPaymentMethod != null && !isLoadingProfile ? _onContinuePressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mocha,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoadingProfile
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    bool isEnabled = true,
  }) {
    bool isSelected = _selectedPaymentMethod == value;
    final Color textColor = isEnabled ? AppColors.charcoal : AppColors.taupe.withValues(alpha: 0.6);
    final Color iconColor = isEnabled ? AppColors.mocha : AppColors.taupe.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: isEnabled
          ? () {
              setState(() {
                _selectedPaymentMethod = value;
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.oat.withValues(alpha: 0.8) : AppColors.milk,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.mocha : AppColors.taupe.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.taupe,
                      ),
                    ),
                  ],
                ),
              ),
              Radio<String>(
                value: value,
                groupValue: _selectedPaymentMethod,
                onChanged: isEnabled
                    ? (String? newValue) {
                        setState(() {
                          _selectedPaymentMethod = newValue;
                        });
                      }
                    : null,
                activeColor: AppColors.mocha,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinuePressed() {
    if (_selectedPaymentMethod == 'wallet') {
      if (_walletBalance < widget.totalAmount) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Insufficient funds in your wallet.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      Navigator.of(context).pop('wallet');
    } else if (_selectedPaymentMethod == 'credit_card') {
      Navigator.of(context).pushNamed(AppRouter.creditCardFormScreen).then((result) {
        if (result != null && result is String) {
          Navigator.of(context).pop(result);
        }
      });
    }
    // Removed cash_on_arrival logic
  }

  Widget _buildStepperIndicator(BuildContext context, int currentStep, int totalSteps) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        bool isActive = index < currentStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.mocha : AppColors.taupe.withValues(alpha: 0.5),
          ),
        );
      }),
    );
  }
}
