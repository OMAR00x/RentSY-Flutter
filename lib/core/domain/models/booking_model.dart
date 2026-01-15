// lib/core/domain/models/booking_model.dart

// لم نعد نحتاج إلى freezed_annotation
// import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:saved/core/domain/models/apartment_model.dart';
import 'package:saved/core/domain/models/user.dart';

// لم نعد نحتاج إلى part directives
// part 'booking_model.freezed.dart';
// part 'booking_model.g.dart';

// لم نعد نحتاج إلى @freezed أو with _$BookingModel
class BookingModel {
  final int id;
  final int userId;
  final int apartmentId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final String status;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ApartmentModel? apartment; // يمكن أن يحتوي على تفاصيل الشقة
  final UserModel? user; // يمكن أن يحتوي على تفاصيل المستخدم

  BookingModel({
    required this.id,
    required this.userId,
    required this.apartmentId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
    this.apartment,
    this.user,
  });

  // ✨ إضافة 1: factory constructor لـ fromJson
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      apartmentId: int.tryParse(json['apartment_id'].toString()) ?? 0,
      startDate: DateTime.tryParse(json['start_date'].toString()) ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'].toString()) ?? DateTime.now(),
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      status: json['status'] ?? 'pending',
      paymentMethod: json['payment_method'] ?? 'unknown',
      createdAt: DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now(),
      apartment: json['apartment'] != null ? ApartmentModel.fromJson(json['apartment']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  // ✨ إضافة 2: دالة toJson
  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'apartment_id': apartmentId,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'total_price': totalPrice,
        'status': status,
        'payment_method': paymentMethod,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'apartment': apartment?.toJson(),
        'user': user?.toJson(),
      };

  // ✨ إضافة 3: دالة copyWith يدوية (لاستخدامها في Cubit)
  BookingModel copyWith({
    int? id,
    int? userId,
    int? apartmentId,
    DateTime? startDate,
    DateTime? endDate,
    double? totalPrice,
    String? status,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
    ApartmentModel? apartment,
    UserModel? user,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      apartmentId: apartmentId ?? this.apartmentId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      apartment: apartment ?? this.apartment,
      user: user ?? this.user,
    );
  }
}
