import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saved/core/domain/models/booking_model.dart';

part 'agent_booking_requests_state.freezed.dart';

@freezed
abstract class AgentBookingRequestsState with _$AgentBookingRequestsState {
  const factory AgentBookingRequestsState.initial() = _Initial;
  const factory AgentBookingRequestsState.loading() = _Loading;
  const factory AgentBookingRequestsState.success(List<BookingModel> requests) = _Success;
  const factory AgentBookingRequestsState.empty() = _Empty;
  const factory AgentBookingRequestsState.error(String message) = _Error;
}
