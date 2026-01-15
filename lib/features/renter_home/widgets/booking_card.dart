// lib/features/renter_home/widgets/booking_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/api_constants.dart'; // For getFullImageUrl
import 'package:saved/core/domain/models/booking_model.dart';
import 'package:saved/features/renter_home/screens/my_bookings_screen.dart'; // For BookingType enum

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final BookingType bookingType;
  final Function(int bookingId)? onCancel;
  final Function(int bookingId, DateTime startDate, DateTime endDate)? onReschedule;
  final Function(int bookingId)? onRate; // For past bookings
  final Function(int bookingId)? onViewDetails; // For past bookings

  const BookingCard({
    super.key,
    required this.booking,
    required this.bookingType,
    this.onCancel,
    this.onReschedule,
    this.onRate,
    this.onViewDetails,
  });

  String _formatDateRange(DateTime start, DateTime end) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  // A simple function to determine the number of nights
  int _getNumberOfNights(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = booking.apartment?.images.isNotEmpty == true
        ? getFullImageUrl(booking.apartment!.images.first.url)
        : null;

    final String statusText;
    Color statusColor;

    switch (booking.status) {
      case 'pending':
        statusText = 'Pending';
        statusColor = Colors.orange;
        break;
      case 'approved':
        statusText = 'Confirmed';
        statusColor = Colors.green;
        break;
      case 'cancelled':
        statusText = 'Cancelled';
        statusColor = Colors.red;
        break;
      case 'rejected':
        statusText = 'Rejected';
        statusColor = Colors.redAccent;
        break;
      default:
        statusText = 'Unknown';
        statusColor = Colors.grey;
    }


    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.milk,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100,
                        height: 100,
                        color: AppColors.taupe.withValues(alpha:0.5),
                        child: const Icon(Icons.broken_image, color: Colors.white),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.taupe.withValues(alpha:0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.apartment, color: Colors.white, size: 50),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        booking.apartment?.title ?? 'Apartment Title',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.charcoal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${booking.apartment?.address ?? 'N/A'}, ${booking.apartment?.city.name ?? 'N/A'}', // Assuming city/area details are available
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.taupe,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDateRange(booking.startDate, booking.endDate),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.charcoal,
                        ),
                      ),
                      Text(
                        '${_getNumberOfNights(booking.startDate, booking.endDate)} Nights', // Assuming 1 guest for simplicity or add guest count
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.taupe,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (bookingType == BookingType.upcoming && booking.status != 'cancelled')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel != null ? () => onCancel!(booking.id) : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancel Booking'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onReschedule != null
                          ? () => onReschedule!(booking.id, booking.startDate, booking.endDate)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.charcoal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Edit Dates', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            else if (bookingType == BookingType.past && booking.status != 'cancelled')
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '\$${booking.totalPrice.abs().toStringAsFixed(2)} TOTAL', // Display total price
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.charcoal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onRate != null ? () => onRate!(booking.id) : null,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.charcoal,
                            side: const BorderSide(color: AppColors.charcoal),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Rate Apartment'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onViewDetails != null ? () => onViewDetails!(booking.id) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.charcoal,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('View Details', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else if (bookingType == BookingType.cancelled || booking.status == 'cancelled')
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha:0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha:0.3)),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'This booking has been cancelled.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
