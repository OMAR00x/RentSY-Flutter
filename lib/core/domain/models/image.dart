class ImageModel {
  final int id;
  final String imageableType;
  final int imageableId;
  final String url;
  final String type;
  final bool isMain;
  final int? order;
  final DateTime? createdAt; 
  final DateTime? updatedAt; 

  ImageModel({
    required this.id,
    required this.imageableType,
    required this.imageableId,
    required this.url,
    required this.type,
    required this.isMain,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      
      id: int.tryParse(json['id'].toString()) ?? 0,
      imageableId: int.tryParse(json['imageable_id'].toString()) ?? 0,
      order: json['order'] != null ? int.tryParse(json['order'].toString()) : null,
      
      imageableType: json['imageable_type'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
      isMain: json['is_main'] ?? false,

      
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "imageable_type": imageableType,
    "imageable_id": imageableId,
    "url": url,
    "type": type,
    "is_main": isMain,
    "order": order,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
