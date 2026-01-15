import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saved/core/domain/models/booking_model.dart';

part 'booking_state.freezed.dart';

@freezed
abstract class BookingState with _$BookingState {
  const factory BookingState.initial() = _Initial;
  const factory BookingState.loading() = _Loading;
  const factory BookingState.success(BookingModel booking) = _Success; // نرجع BookingModel عند النجاح
  const factory BookingState.error(String message) = _Error;
}
