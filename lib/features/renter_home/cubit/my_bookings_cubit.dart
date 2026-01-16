// lib/features/renter_home/cubit/my_bookings_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:saved/core/domain/models/booking_model.dart'; // <--- REMOVE THIS LINE

import 'package:saved/features/renter_home/cubit/my_bookings_state.dart';
import 'package:saved/features/renter_home/repository/renter_repository.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  final RenterRepository _renterRepository;

  MyBookingsCubit(this._renterRepository) : super(const MyBookingsState.initial());

  Future<void> fetchMyBookings() async {
    emit(const MyBookingsState.loading());
    try {
      final bookings = await _renterRepository.getMyBookings();
      emit(MyBookingsState.success(bookings));
    } catch (e) {
      emit(MyBookingsState.error(e.toString()));
    }
  }

  Future<void> rescheduleBooking({
    required int bookingId,
    required DateTime newStartDate,
    required DateTime newEndDate,
  }) async {
    try {
      await _renterRepository.rescheduleBooking(
        bookingId: bookingId,
        newStartDate: newStartDate,
        newEndDate: newEndDate,
      );
      await fetchMyBookings();
    } catch (e) {
      emit(MyBookingsState.error(e.toString()));
    }
  }

  Future<void> cancelBooking({required int bookingId}) async {
    try {
      await _renterRepository.cancelBooking(bookingId: bookingId);
      await fetchMyBookings();
    } catch (e) {
      emit(MyBookingsState.error(e.toString()));
    }
  }
}
