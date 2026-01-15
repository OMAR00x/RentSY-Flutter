// lib/features/renter_home/screens/credit_card_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/core/widgets/loading_widget.dart';

class CreditCardFormScreen extends StatefulWidget {
  const CreditCardFormScreen({super.key});

  @override
  State<CreditCardFormScreen> createState() => _CreditCardFormScreenState();
}

class _CreditCardFormScreenState extends State<CreditCardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call for payment processing
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        // In a real app, you would send these details (preferably tokenized) to your backend
        // and handle the response. For now, we simulate success and pop.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment processed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop('credit_card'); // Pass back the chosen method
      });
    }
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
          'Electronic Payment',
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStepperIndicator(context, 2, 3), // Step 2 of 3
              const SizedBox(height: 30),
              // Make sure to add 'assets/images/visa_logo.png' in your pubspec.yaml
              // Or replace with an Icon(Icons.payment) if no asset is available.
              Image.asset(
                'assets/images/visa_logo.png', // Or 'assets/images/visa.jpg' as per your original file
                height: 80,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.payment, size: 80, color: AppColors.taupe),
              ),
              const SizedBox(height: 40),
              _buildInputField(
                controller: _cardNumberController,
                label: 'Card Number',
                hint: '•••• •••• •••• ••••',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  if (value.replaceAll(' ', '').length != 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              // Removed Expiry Date, CVV, Card Holder Name fields
              const SizedBox(height: 40),
              Text(
                'lock Secure SSL Connection. Your information is encrypted.',
                style: TextStyle(color: AppColors.taupe.withValues(alpha: 0.8), fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mocha,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const LoadingWidget()
                      : const Text(
                          'Next',
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
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.taupe.withValues(alpha: 0.6)),
            filled: true,
            fillColor: AppColors.milk,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
          style: const TextStyle(color: AppColors.charcoal),
        ),
      ],
    );
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

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String newText = newValue.text.replaceAll(RegExp(r'\s+'), '');
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      int nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != newText.length) {
        buffer.write(' ');
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.toString().length),
    );
  }
}
// Removed ExpiryDateFormatter
