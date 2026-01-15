import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/features/agent_home/cubit/agent_booking_requests_state.dart';
import 'package:saved/features/agent_home/repository/agent_repository.dart';
import 'package:saved/core/domain/models/booking_model.dart';
import 'package:saved/core/domain/models/apartment_model.dart';

class AgentBookingRequestsCubit extends Cubit<AgentBookingRequestsState> {
  final AgentRepository _agentRepository;

  AgentBookingRequestsCubit(this._agentRepository) : super(const AgentBookingRequestsState.initial());

  Future<void> fetchBookingRequests() async {
    emit(const AgentBookingRequestsState.loading());
    try {
      final List<ApartmentModel> myApartments = await _agentRepository.getMyApartments();
      List<BookingModel> allBookingRequests = [];

      if (myApartments.isEmpty) {
        emit(const AgentBookingRequestsState.empty());
        return;
      }

      for (var apartment in myApartments) {
        final List<BookingModel> apartmentRequests = await _agentRepository.getAgentBookingRequests(
          apartmentId: apartment.id,
        );
        allBookingRequests.addAll(apartmentRequests);
      }

      final pendingRequests = allBookingRequests.where((b) => b.status == 'pending').toList();

      if (pendingRequests.isEmpty) {
        emit(const AgentBookingRequestsState.empty());
      } else {
        emit(AgentBookingRequestsState.success(pendingRequests));
      }
    } catch (e) {
      emit(AgentBookingRequestsState.error(e.toString()));
    }
  }

  // ✨ دالة واحدة لتحديث الحالة
  Future<void> updateBookingStatus(int bookingId, String status) async {
    try {
      await _agentRepository.updateBookingStatus(bookingId, status);
      await fetchBookingRequests(); // إعادة جلب الطلبات لتحديث الواجهة
    } catch (e) {
      emit(AgentBookingRequestsState.error(e.toString()));
    }
  }
}
