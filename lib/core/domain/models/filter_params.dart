class FilterParams {
  final int? cityId;
  final int? areaId;
  final double? minPrice;
  final double? maxPrice;
  final int? minRooms;
  final List<int>? amenityIds;
  final String? searchQuery;

  FilterParams({
    this.cityId,
    this.areaId,
    this.minPrice,
    this.maxPrice,
    this.minRooms,
    this.amenityIds,
    this.searchQuery,
  });

  // لتحويل معايير الفلترة إلى Map يمكن استخدامها كـ query parameters
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    if (cityId != null) map['city_id'] = cityId.toString();
    if (areaId != null) map['area_id'] = areaId.toString();
    if (minPrice != null) map['min_price'] = minPrice.toString();
    if (maxPrice != null) map['max_price'] = maxPrice.toString();
    if (minRooms != null) map['rooms'] = minRooms.toString(); // API expects 'rooms' as minimum
    if (searchQuery != null && searchQuery!.isNotEmpty) map['search'] = searchQuery; // API expects 'search' for text

    // Dio handles list serialization for queryParameters (e.g., amenities[]=1&amenities[]=2)
    if (amenityIds != null && amenityIds!.isNotEmpty) {
      map['amenities'] = amenityIds;
    }

    return map;
  }

  // لإنشاء نسخة جديدة من FilterParams مع تحديث بعض الحقول
  FilterParams copyWith({
    int? cityId,
    int? areaId,
    double? minPrice,
    double? maxPrice,
    int? minRooms,
    List<int>? amenityIds,
    String? searchQuery,
  }) {
    return FilterParams(
      cityId: cityId ?? this.cityId,
      areaId: areaId ?? this.areaId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRooms: minRooms ?? this.minRooms,
      amenityIds: amenityIds ?? this.amenityIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

