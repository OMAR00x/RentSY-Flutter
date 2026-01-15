import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart'; // For FilteringTextInputFormatter
import 'package:saved/constants/app_colors.dart';
import 'package:saved/core/widgets/loading_widget.dart';
import 'package:saved/features/profile/cubit/profile_cubit.dart'; // Using ProfileCubit for wallet initially
import 'package:saved/features/profile/cubit/profile_state.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // It's assumed ProfileCubit already fetches the user with walletBalance.
    // If a dedicated WalletCubit is created later, this would change.
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _addFunds() {
    final String amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount to add.')),
      );
      return;
    }
    final double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid positive amount.')),
      );
      return;
    }

    // TODO: Implement actual add funds logic via ProfileCubit (or WalletCubit)
    // For now, simulate success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Simulating adding \$${amount.toStringAsFixed(2)} to wallet.')),
    );
    Navigator.of(context).pop(); // Go back to profile screen after simulating add funds
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
          'My Wallet',
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          state.mapOrNull(
            loadSuccess: (userState) {
              // Optionally refresh UI if wallet balance is updated elsewhere
            },
            updateSuccess: (userState) {
              // Optionally refresh UI if wallet balance is updated elsewhere
            },
            loadFailure: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load wallet: $message'), backgroundColor: Colors.red),
              );
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loadSuccess: (user) => _buildWalletContent(user.walletBalance),
            updateSuccess: (user) => _buildWalletContent(user.walletBalance),
            loadInProgress: () => const Center(child: LoadingWidget()),
            orElse: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load wallet data.'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().fetchProfile(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWalletContent(double currentBalance) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.mocha,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${currentBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 40),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Add Funds',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Enter amount',
              hintStyle: TextStyle(color: AppColors.taupe.withOpacity(0.6)),
              filled: true,
              fillColor: AppColors.milk,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              prefixIcon: const Icon(Icons.attach_money, color: AppColors.taupe),
            ),
            style: const TextStyle(color: AppColors.charcoal),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _addFunds, // Call the add funds method
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.charcoal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Add Funds to Wallet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // TODO: Add transaction history section here
          const Text(
            'Transaction History (Coming Soon)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.charcoal,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'No transactions yet.',
                style: TextStyle(color: AppColors.taupe.withOpacity(0.8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
