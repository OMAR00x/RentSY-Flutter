// lib/features/renter_home/screens/my_bookings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/domain/models/booking_model.dart';
import 'package:saved/features/renter_home/cubit/my_bookings_cubit.dart';
import 'package:saved/features/renter_home/cubit/my_bookings_state.dart';
import 'package:saved/features/renter_home/widgets/booking_card.dart';
// ✨ Added import for ProfileCubit
import 'package:saved/features/profile/cubit/profile_cubit.dart';

enum BookingType { upcoming, past, cancelled }

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadBookings() {
    context.read<MyBookingsCubit>().fetchMyBookings();
  }

  // Helper functions to categorize bookings
  List<BookingModel> _getUpcomingBookings(List<BookingModel> allBookings) {
    return allBookings
        .where((b) => b.status == 'pending')
        .toList();
  }

  List<BookingModel> _getPastBookings(List<BookingModel> allBookings) {
    return allBookings
        .where((b) => b.status == 'approved')
        .toList();
  }

  List<BookingModel> _getCancelledBookings(List<BookingModel> allBookings) {
    return allBookings.where((b) => b.status == 'cancelled').toList();
  }

  @override
  Widget build(BuildContext context) {
    _loadBookings();
    return Scaffold(
      backgroundColor: AppColors.oat,
      appBar: AppBar(
        backgroundColor: AppColors.milk,
        elevation: 0,
        leading: const BackButton(color: AppColors.charcoal),
        title: const Text(
          AppStrings.myBookings,
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.charcoal,
          unselectedLabelColor: AppColors.taupe,
          indicatorColor: AppColors.mocha,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: BlocConsumer<MyBookingsCubit, MyBookingsState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red),
              );
            },
            // ✨ Added: Refresh user profile when MyBookingsState is success (after any booking action)
            success: (bookings) {
              context.read<ProfileCubit>().fetchProfile();
            }
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text('Load your bookings')),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (bookings) {
              final upcomingBookings = _getUpcomingBookings(bookings);
              final pastBookings = _getPastBookings(bookings);
              final cancelledBookings = _getCancelledBookings(bookings);

              return TabBarView(
                controller: _tabController,
                children: [
                  _BookingList(bookings: upcomingBookings, type: BookingType.upcoming),
                  _BookingList(bookings: pastBookings, type: BookingType.past),
                  _BookingList(bookings: cancelledBookings, type: BookingType.cancelled),
                ],
              );
            },
            error: (message) => Center(child: Text('Failed to load bookings: $message')),
          );
        },
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  final BookingType type;
  const _BookingList({required this.bookings, required this.type});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      String message;
      if (type == BookingType.upcoming) {
        message = 'You have no upcoming bookings.';
      } else if (type == BookingType.past) {
        message = 'You have no past bookings.';
      } else {
        message = 'You have no cancelled bookings.';
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                type == BookingType.upcoming ? Icons.calendar_today_outlined :
                type == BookingType.past ? Icons.history : Icons.cancel_outlined,
                size: 80,
                color: AppColors.taupe,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.charcoal,
                ),
              ),
              if (type == BookingType.past) ...[
                const SizedBox(height: 24),
              ]
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(
          booking: bookings[index],
          bookingType: type,
          onCancel: (bookingId) {
            context.read<MyBookingsCubit>().cancelBooking(bookingId: bookingId);
          },
          onReschedule: (bookingId, startDate, endDate) {
            _showRescheduleDialog(context, bookingId, startDate, endDate);
          },
        );
      },
    );
  }

  void _showRescheduleDialog(BuildContext context, int bookingId, DateTime currentStartDate, DateTime currentEndDate) {
    DateTime? newStartDate = currentStartDate;
    DateTime? newEndDate = currentEndDate;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Reschedule Booking'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: newStartDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          newStartDate = pickedDate;
                          if (newEndDate != null && newEndDate!.isBefore(newStartDate!)) {
                            newEndDate = newStartDate!.add(const Duration(days: 1));
                          }
                        });
                      }
                    },
                    child: Text('New Start Date: ${newStartDate!.toIso8601String().split('T').first}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: newEndDate,
                        firstDate: newStartDate ?? DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          newEndDate = pickedDate;
                          if (newStartDate != null && newStartDate!.isAfter(newEndDate!)) {
                            newStartDate = newEndDate!.subtract(const Duration(days: 1));
                          }
                        });
                      }
                    },
                    child: Text('New End Date: ${newEndDate!.toIso8601String().split('T').first}'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newStartDate != null && newEndDate != null && newEndDate!.isAfter(newStartDate!)) {
                  context.read<MyBookingsCubit>().rescheduleBooking(
                    bookingId: bookingId,
                    newStartDate: newStartDate!,
                    newEndDate: newEndDate!,
                  );
                  Navigator.of(dialogContext).pop();
                } else {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Please select valid start and end dates.')),
                  );
                }
              },
              child: const Text('Reschedule'),
            ),
          ],
        );
      },
    );
  }
}
