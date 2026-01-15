// lib/features/renter_home/cubit/my_bookings_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saved/core/domain/models/booking_model.dart';

part 'my_bookings_state.freezed.dart';

@freezed
abstract class MyBookingsState with _$MyBookingsState {
  const factory MyBookingsState.initial() = _Initial;
  const factory MyBookingsState.loading() = _Loading;
  // ✨ هنا، BookingModel لم يعد Freezed.
  // إذا استمرت الأخطاء، قد تحتاج لإزالة this.booking من booking_state.freezed.dart
  // أو لجعل BookingState لا يحتوي على BookingModel مباشرة.
  const factory MyBookingsState.success(List<BookingModel> bookings) = _Success;
  const factory MyBookingsState.error(String message) = _Error;
}
