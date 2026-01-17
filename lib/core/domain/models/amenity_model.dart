

class AmenityModel {
  final int id;
  final String name;

  AmenityModel({required this.id, required this.name});

  factory AmenityModel.fromJson(Map<String, dynamic> json) {
    return AmenityModel(
     
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
