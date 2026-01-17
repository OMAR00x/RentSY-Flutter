import 'package:saved/core/domain/models/amenity_model.dart';
import 'package:saved/core/domain/models/city_model.dart';
import 'package:saved/core/domain/models/image.dart';
import 'package:saved/core/domain/models/user.dart';

class ApartmentModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String priceType;
  final int rooms;
  final String status;
  final String address;
  bool isFavorite; 
  final List<ImageModel> images;
  final CityModel city;
  final UserModel owner;
  final List<AmenityModel> amenities;
 final int? favoritesCount; 

  String? get mainImageUrl {
    try {
      return images.firstWhere((img) => img.isMain).url;
    } catch (e) {
      return images.isNotEmpty ? images.first.url : null;
    }
  }

  ApartmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.priceType,
    required this.rooms,
    required this.status,
    required this.address,
    this.isFavorite = false, 
    required this.images,
    required this.city,
    required this.owner,
    required this.amenities,
    this.favoritesCount, 
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    return ApartmentModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      rooms: int.tryParse(json['rooms'].toString()) ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      priceType: json['price_type'] ?? 'daily',
      status: json['status'] ?? 'inactive',
      address: json['address'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      images: (json['images'] as List? ?? []).map((i) => ImageModel.fromJson(i)).toList(),
      city: json['city'] != null ? CityModel.fromJson(json['city']) : CityModel(id: 0, name: 'Unknown'),
      owner: json['owner'] != null ? UserModel.fromJson(json['owner']) : UserModel.fromJson({'id': 0, 'first_name': 'Unknown', 'last_name': 'User', 'phone': '', 'role': '', 'status': '', 'token': ''}),
      amenities: (json['amenities'] as List? ?? []).map((a) => AmenityModel.fromJson(a)).toList(),
      favoritesCount: json['favorites_count'] != null ? int.tryParse(json['favorites_count'].toString()) : null, 
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "price_type": priceType,
        "rooms": rooms,
        "status": status,
        "address": address,
        "is_favorite": isFavorite,
        "images": images.map((e) => e.toJson()).toList(),
        "city": city.toJson(),
        "owner": owner.toJson(),
        "amenities": amenities.map((e) => e.toJson()).toList(),
        "favorites_count": favoritesCount, 
      };

 
  ApartmentModel copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? priceType,
    int? rooms,
    String? status,
    String? address,
    bool? isFavorite,
    List<ImageModel>? images,
    CityModel? city,
    UserModel? owner,
    List<AmenityModel>? amenities,
    int? favoritesCount,
  }) {
    return ApartmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      priceType: priceType ?? this.priceType,
      rooms: rooms ?? this.rooms,
      status: status ?? this.status,
      address: address ?? this.address,
      isFavorite: isFavorite ?? this.isFavorite,
      images: images ?? this.images,
      city: city ?? this.city,
      owner: owner ?? this.owner,
      amenities: amenities ?? this.amenities,
      favoritesCount: favoritesCount ?? this.favoritesCount,
    );
  }
}
