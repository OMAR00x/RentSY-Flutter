// lib/core/domain/models/area_model.dart

class AreaModel {
  final int id;
  final String name;
  final int cityId;

  AreaModel({required this.id, required this.name, required this.cityId});

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Unknown Area',
      cityId: int.tryParse(json['city_id'].toString()) ?? 0,
    );
  }
}
