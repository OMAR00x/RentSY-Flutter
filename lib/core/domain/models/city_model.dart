// lib/core/domain/models/city_model.dart

class CityModel {
  final int id;
  final String name;

  CityModel({required this.id, required this.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      // --- ✨ إصلاح: تحويل الـ ID إلى رقم بأمان ---
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Unknown City',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
