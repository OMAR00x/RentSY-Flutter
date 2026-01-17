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

  
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    if (cityId != null) map['city_id'] = cityId.toString();
    if (areaId != null) map['area_id'] = areaId.toString();
    if (minPrice != null) map['min_price'] = minPrice.toString();
    if (maxPrice != null) map['max_price'] = maxPrice.toString();
    if (minRooms != null) map['rooms'] = minRooms.toString(); 
    if (searchQuery != null && searchQuery!.isNotEmpty) map['search'] = searchQuery; 
    
    if (amenityIds != null && amenityIds!.isNotEmpty) {
      map['amenities'] = amenityIds;
    }

    return map;
  }

  
  FilterParams copyWith({
    int? cityId,
    int? areaId,
    double? minPrice,
    double? maxPrice,
    int? minRooms,
    List<int>? amenityIds,
    String? searchQuery,
    bool resetCity = false,
    bool resetArea = false,
    bool resetMinPrice = false,
    bool resetMaxPrice = false,
    bool resetMinRooms = false,
    bool resetAmenities = false,
    bool resetSearchQuery = false,
  }) {
    return FilterParams(
      cityId: resetCity ? null : (cityId ?? this.cityId),
      areaId: resetArea ? null : (areaId ?? this.areaId),
      minPrice: resetMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: resetMaxPrice ? null : (maxPrice ?? this.maxPrice),
      minRooms: resetMinRooms ? null : (minRooms ?? this.minRooms),
      amenityIds: resetAmenities ? null : (amenityIds ?? this.amenityIds),
      searchQuery: resetSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }
}

