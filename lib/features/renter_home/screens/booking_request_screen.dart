// lib/features/renter_home/screens/booking_request_screen.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/core/domain/models/apartment_model.dart';
import 'package:saved/features/renter_home/cubit/booking_cubit.dart';
import 'package:saved/features/renter_home/cubit/booking_state.dart';
import 'package:saved/features/renter_home/cubit/my_bookings_cubit.dart';
import 'package:table_calendar/table_calendar.dart';
// ✨ Added import for ProfileCubit
import 'package:saved/features/profile/cubit/profile_cubit.dart';

class BookingRequestScreen extends StatefulWidget {
  final ApartmentModel apartment;
  const BookingRequestScreen({super.key, required this.apartment});

  @override
  State<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  DateTime _focusedDay = DateTime.now();
  final String _paymentMethod = 'wallet';

  int get _numberOfNights {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    return _checkOutDate!.difference(_checkInDate!).inDays;
  }

  double get _baseRate {
    return widget.apartment.price * _numberOfNights;
  }

  double get _serviceFee {
    return 0.0;
  }

  double get _totalAmount {
    return _baseRate + _serviceFee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oat,
      appBar: AppBar(
        backgroundColor: AppColors.milk,
        elevation: 0,
        leading: const BackButton(color: AppColors.charcoal),
        title: const Text(
          'Booking Request',
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          state.whenOrNull(
            loading: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Submitting booking request...')),
              );
            },
            success: (booking) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking request submitted successfully. Waiting for owner approval.'),
                  backgroundColor: Colors.green,
                ),
              );
              // ✨ Added: Refresh user profile after successful booking
              context.read<ProfileCubit>().fetchProfile();
              
              // ✨ أضف هذا السطر هنا:
              // بعد إنشاء حجز جديد بنجاح، اطلب من MyBookingsCubit إعادة جلب الحجوزات.
              // هذا يفترض أن MyBookingsCubit متاح في الـ context الخاص بـ BookingRequestScreen
              // (وهو أمر وارد إذا كانا جزءاً من نفس ميزة renter_home).
              try {
                context.read<MyBookingsCubit>().fetchMyBookings();
              } catch (e) {
                // قد تحتاج للتعامل مع هذا الاستثناء إذا لم يكن MyBookingsCubit متاحاً في السياق
                // (أقل احتمالاً في تطبيق منظم جيداً).
                log('Error accessing MyBookingsCubit to refresh: $e');
              }
              
              Navigator.of(context).pop();
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to submit booking request: $message'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _dateCard('CHECK-IN', _checkInDate, () => _selectDate(context, isCheckIn: true)),
              const SizedBox(height: 12),
              _dateCard('CHECK-OUT', _checkOutDate, () => _selectDate(context, isCheckIn: false)),
              const SizedBox(height: 16),
              _calendarCard(),
              const SizedBox(height: 16),
              _priceDetailsCard(),
              const SizedBox(height: 24),
              _confirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateCard(String title, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.milk,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.taupe,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date != null
                      ? DateFormat('MMM dd, yyyy').format(date)
                      : '--',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
              ],
            ),
            const Icon(Icons.calendar_today, color: AppColors.taupe),
          ],
        ),
      ),
    );
  }

  Widget _calendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.milk,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: TableCalendar(
        firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDay: DateTime.utc(DateTime.now().year + 1, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          if (_checkInDate == null) return false;
          if (_checkOutDate == null) {
            return isSameDay(day, _checkInDate);
          }
          return (day.isAfter(_checkInDate!.subtract(const Duration(days: 1))) &&
              day.isBefore(_checkOutDate!.add(const Duration(days: 1)))) ||
              isSameDay(day, _checkInDate) ||
              isSameDay(day, _checkOutDate);
        },
        onDaySelected: (selectedDay, focused) {
          setState(() {
            _focusedDay = focused;
            if (_checkInDate == null || (_checkOutDate != null && selectedDay.isBefore(_checkInDate!))) {
              _checkInDate = selectedDay;
              _checkOutDate = null;
            } else if (selectedDay.isAfter(_checkInDate!)) {
              _checkOutDate = selectedDay;
            } else if (isSameDay(selectedDay, _checkInDate!)) {
              _checkOutDate = null;
            }
          });
        },
        calendarStyle: CalendarStyle(
          rangeHighlightColor: AppColors.charcoal.withOpacity(0.08),
          selectedDecoration: const BoxDecoration(
            color: AppColors.charcoal,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            border: Border.all(color: AppColors.charcoal),
            shape: BoxShape.circle,
          ),
          rangeStartDecoration: const BoxDecoration(
            color: AppColors.charcoal,
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: const BoxDecoration(
            color: AppColors.charcoal,
            shape: BoxShape.circle,
          ),
          withinRangeDecoration: const BoxDecoration(
            color: AppColors.taupe,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: const TextStyle(color: AppColors.charcoal),
          weekendTextStyle: const TextStyle(color: AppColors.charcoal),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
      ),
    );
  }

  Widget _priceDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.milk,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _priceRow('Base Rate (${_numberOfNights} nights)', _baseRate),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.charcoal,
                ),
              ),
              Text(
                '\$${_totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mocha,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.taupe)),
        Text('\$${value.toStringAsFixed(2)}',
            style: const TextStyle(color: AppColors.charcoal)),
      ],
    );
  }

  Widget _confirmButton() {
    final bool canBook = _checkInDate != null && _checkOutDate != null && _numberOfNights > 0;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.charcoal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: canBook
            ? () {
                context.read<BookingCubit>().createBooking(
                  apartmentId: widget.apartment.id,
                  startDate: _checkInDate!,
                  endDate: _checkOutDate!,
                  paymentMethod: _paymentMethod,
                );
              }
            : null,
        child: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const CircularProgressIndicator(color: Colors.white),
              orElse: () => const Text(
                'Submit Booking Request',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isCheckIn}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (_checkInDate ?? _focusedDay)
          : (_checkOutDate ?? _focusedDay.add(const Duration(days: 1))),
      firstDate: DateTime.now(),
      lastDate: DateTime.utc(DateTime.now().year + 1, 12, 31),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.charcoal,
            colorScheme: const ColorScheme.light(primary: AppColors.charcoal),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate != null && _checkInDate!.isAfter(_checkOutDate!)) {
            _checkOutDate = null;
          }
        } else {
          _checkOutDate = picked;
          if (_checkInDate != null && _checkOutDate!.isBefore(_checkInDate!)) {
            _checkInDate = null;
          }
        }
        _focusedDay = picked;
      });
    }
  }
}
