// lib/core/domain/models/user.dart
import 'package:saved/core/domain/models/image.dart';

class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String role;
  final String status;
  final String token;
  final DateTime? birthdate;
  final ImageModel? avatar;
  final ImageModel? idFront;
  final ImageModel? idBack;
  final double walletBalance; // ✨ New: Wallet Balance

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.status,
    required this.token,
    this.birthdate,
    this.avatar,
    this.idFront,
    this.idBack,
    this.walletBalance = 0.0, // ✨ New: Default to 0.0
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      status: json["status"] ?? "",
      token: json["token"] ?? "",
      birthdate: json['birthdate'] != null ? DateTime.tryParse(json['birthdate']) : null,
      avatar: json['avatar'] != null ? ImageModel.fromJson(json['avatar']) : null,
      idFront: json['id_front'] != null ? ImageModel.fromJson(json['id_front']) : null,
      idBack: json['id_back'] != null ? ImageModel.fromJson(json['id_back']) : null,
      walletBalance: double.tryParse(json['wallet']?.toString() ?? '0.0') ?? 0.0, // ✨ Modified: Reads from 'wallet'
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "role": role,
    "status": status,
    "token": token,
    "birthdate": birthdate?.toIso8601String(),
    "avatar": avatar?.toJson(),
    "id_front": idFront?.toJson(),
    "id_back": idBack?.toJson(),
    "wallet": walletBalance, // ✨ Modified: Uses 'wallet' for consistency
  };

  UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? role,
    String? status,
    String? token,
    DateTime? birthdate,
    ImageModel? avatar,
    ImageModel? idFront,
    ImageModel? idBack,
    double? walletBalance,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      token: token ?? this.token,
      birthdate: birthdate ?? this.birthdate,
      avatar: avatar ?? this.avatar,
      idFront: idFront ?? this.idFront,
      idBack: idBack ?? this.idBack,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}
