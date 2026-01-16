import 'package:flutter/material.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/core/domain/models/booking_model.dart';
import 'package:saved/core/services/api_client.dart';

class RateBookingScreen extends StatefulWidget {
  final BookingModel booking;

  const RateBookingScreen({super.key, required this.booking});

  @override
  State<RateBookingScreen> createState() => _RateBookingScreenState();
}

class _RateBookingScreenState extends State<RateBookingScreen> {
  int _rating = 0;
  bool _isLoading = false;

  Future<void> _submitRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiClient().dio.post('/reviews', data: {
        'booking_id': widget.booking.id,
        'rating': _rating,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating submitted successfully'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit rating: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oat,
      appBar: AppBar(
        backgroundColor: AppColors.milk,
        elevation: 0,
        leading: const BackButton(color: AppColors.charcoal),
        title: const Text('Rate Your Stay', style: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.booking.apartment?.title ?? 'Apartment',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.charcoal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Text('How was your experience?', style: TextStyle(fontSize: 16, color: AppColors.taupe)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  iconSize: 48,
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.mocha,
                  ),
                );
              }),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.charcoal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Rating', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
