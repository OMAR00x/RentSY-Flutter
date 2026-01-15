// lib/core/domain/models/amenity_model.dart

class AmenityModel {
  final int id;
  final String name;

  AmenityModel({required this.id, required this.name});

  factory AmenityModel.fromJson(Map<String, dynamic> json) {
    return AmenityModel(
      // --- ✨ إصلاح: تحويل الـ ID إلى رقم بأمان ---
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Unknown Amenity',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
