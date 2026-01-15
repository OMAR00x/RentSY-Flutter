import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saved/constants/api_constants.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/domain/models/booking_model.dart';
import 'package:saved/core/widgets/loading_widget.dart';
import 'package:saved/features/agent_home/cubit/agent_booking_requests_cubit.dart';
import 'package:saved/features/agent_home/cubit/agent_booking_requests_state.dart';

class BookingRequestsScreen extends StatefulWidget {
  const BookingRequestsScreen({super.key});

  @override
  State<BookingRequestsScreen> createState() => _BookingRequestsScreenState();
}

class _BookingRequestsScreenState extends State<BookingRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AgentBookingRequestsCubit>().fetchBookingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oat,
      appBar: AppBar(
        title: const Text(AppStrings.bookingRequestsTitle, style: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.milk,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.charcoal),
      ),
      body: BlocBuilder<AgentBookingRequestsCubit, AgentBookingRequestsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const LoadingWidget(),
            loading: () => const LoadingWidget(),
            error: (message) => Center(child: Text('Error: $message')),
            empty: () => _buildEmptyMessage(),
            success: (requests) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<AgentBookingRequestsCubit>().fetchBookingRequests();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final booking = requests[index];
                    return BookingRequestCard(
                      booking: booking,
                      onAccept: () {
                        context.read<AgentBookingRequestsCubit>().updateBookingStatus(booking.id, 'approved'); // ✨ استدعاء الدالة الجديدة
                      },
                      onReject: () {
                        context.read<AgentBookingRequestsCubit>().updateBookingStatus(booking.id, 'rejected'); // ✨ استدعاء الدالة الجديدة
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.inbox_outlined, size: 60, color: AppColors.taupe),
            SizedBox(height: 16),
            Text(AppStrings.noNewRequests, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
            SizedBox(height: 8),
            Text(
              AppStrings.noNewRequestsSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.mocha),
            ),
          ],
        ),
      ),
    );
  }
}


// ✨ مكون Card جديد لطلبات الحجز (تم تعديله ليطابق الصورة)
class BookingRequestCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const BookingRequestCard({
    super.key,
    required this.booking,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    // التأكد من وجود بيانات المستخدم والشقة
    final String guestName = '${booking.user?.firstName ?? 'Unknown'} ${booking.user?.lastName ?? 'User'}';
    final String apartmentTitle = booking.apartment?.title ?? 'Unknown Apartment';
    final String? guestAvatarUrl = booking.user?.avatar?.url;
    final String formattedStartDate = DateFormat('MMM dd, yyyy').format(booking.startDate);
    final String formattedEndDate = DateFormat('MMM dd, yyyy').format(booking.endDate);
    final String totalPrice = booking.totalPrice.toStringAsFixed(2);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.milk, // لون خلفية البطاقة
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.taupe.withValues(alpha:0.3),
                backgroundImage: guestAvatarUrl != null
                    ? CachedNetworkImageProvider(getFullImageUrl(guestAvatarUrl))
                    : null,
                child: guestAvatarUrl == null
                    ? const Icon(Icons.person, color: AppColors.charcoal)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(guestName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
                  Text(apartmentTitle, style: const TextStyle(fontSize: 14, color: AppColors.mocha)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Check-in Date:', formattedStartDate),
          _buildDetailRow('Check-out Date:', formattedEndDate),
          _buildDetailRow('Total Amount:', '\$$totalPrice'),
          // ✨ إذا أردت عرض حالة الحجز (Pending)
          _buildDetailRow('Status:', booking.status.toUpperCase(), color: AppColors.taupe),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: onReject,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(AppStrings.reject),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.charcoal, // استخدام لون التطبيق الرئيسي
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(AppStrings.accept),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color color = AppColors.charcoal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.mocha, fontSize: 14)),
          Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

