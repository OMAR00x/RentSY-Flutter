import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/features/renter_home/cubit/booking_state.dart';
import 'package:saved/features/renter_home/repository/renter_repository.dart';

class BookingCubit extends Cubit<BookingState> {
  final RenterRepository _renterRepository;

  BookingCubit(this._renterRepository) : super(const BookingState.initial());

  Future<void> createBooking({
    required int apartmentId,
    required DateTime startDate,
    required DateTime endDate,
    String paymentMethod = 'wallet', // القيمة الافتراضية كما ذكرتها
  }) async {
    emit(const BookingState.loading());
    try {
      final booking = await _renterRepository.createBooking(
        apartmentId: apartmentId,
        startDate: startDate,
        endDate: endDate,
        paymentMethod: paymentMethod,
      );
      emit(BookingState.success(booking));
    } catch (e) {
      emit(BookingState.error(e.toString()));
    }
  }
}
