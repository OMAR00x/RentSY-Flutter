import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saved/constants/app_colors.dart';
//import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/domain/models/amenity_model.dart';
import 'package:saved/core/domain/models/area_model.dart';
import 'package:saved/core/domain/models/city_model.dart';
import 'package:saved/core/domain/models/filter_params.dart';
import 'package:saved/core/widgets/loading_widget.dart';
import 'package:saved/features/agent_home/repository/agent_repository.dart';
import 'package:saved/features/renter_home/cubit/filter_cubit.dart';

class FilterScreen extends StatelessWidget {
  final FilterParams initialFilterParams; // لاستخدام الفلاتر الحالية كقيم ابتدائية

  const FilterScreen({super.key, required this.initialFilterParams});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterCubit(
        context.read<AgentRepository>(), // توفير AgentRepository لـ FilterCubit
        initialParams: initialFilterParams,
      )..loadFilterOptions(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Filter Apartments'),
          backgroundColor: AppColors.oat,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.charcoal),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<FilterCubit>().resetFilters();
              },
              child: const Text('Reset', style: TextStyle(color: AppColors.charcoal)),
            ),
          ],
        ),
        body: BlocBuilder<FilterCubit, FilterState>(
          builder: (context, state) {
            return state.when(
              initial: () => const LoadingWidget(),
              loading: () => const LoadingWidget(),
              error: (message) => Center(child: Text('Error: $message')),
              success: (cities, areas, allAmenities, currentFilterParams) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            // قسم اختيار المدينة والمنطقة
                            _buildCityAreaSelection(context, cities, areas, currentFilterParams),
                            const SizedBox(height: 20),
                            // قسم نطاق السعر
                            _buildPriceRange(context, currentFilterParams),
                            const SizedBox(height: 20),
                            // قسم عدد الغرف
                            _buildRoomsSelection(context, currentFilterParams),
                            const SizedBox(height: 20),
                            // قسم الميزات (Amenities)
                            _buildAmenitiesSelection(context, allAmenities, currentFilterParams),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      // زر تطبيق الفلاتر
                      _buildApplyButton(context),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // --- دوال بناء أقسام الواجهة ---

  Widget _buildCityAreaSelection(
      BuildContext context,
      List<CityModel> cities,
      List<AreaModel> areas,
      FilterParams currentFilterParams,
      ) {
    final selectedCity = cities.firstWhere(
            (c) => c.id == currentFilterParams.cityId,
        orElse: () => CityModel(id: 0, name: 'Select City'));
    final selectedArea = areas.firstWhere(
            (a) => a.id == currentFilterParams.areaId,
        orElse: () => AreaModel(id: 0, name: 'Select Area', cityId: 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('City', style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
        const SizedBox(height: 8),
        DropdownButtonFormField<CityModel>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          initialValue: currentFilterParams.cityId != null && selectedCity.id != 0 ? selectedCity : null,
          hint: const Text('Select City'),
          onChanged: (CityModel? city) {
            context.read<FilterCubit>().onCitySelected(city);
          },
          items: cities.map((CityModel city) {
            return DropdownMenuItem<CityModel>(
              value: city,
              child: Text(city.name),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text('Area', style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
        const SizedBox(height: 8),
        DropdownButtonFormField<AreaModel>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          initialValue: currentFilterParams.areaId != null && selectedArea.id != 0 ? selectedArea : null,
          hint: const Text('Select Area'),
          onChanged: areas.isEmpty
              ? null // تعطيل إذا لم تكن هناك مناطق للمدينة المختارة
              : (AreaModel? area) {
            context.read<FilterCubit>().onAreaSelected(area);
          },
          items: areas.map((AreaModel area) {
            return DropdownMenuItem<AreaModel>(
              value: area,
              child: Text(area.name),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRange(BuildContext context, FilterParams currentFilterParams) {
    final double currentMinPrice = currentFilterParams.minPrice ?? 0;
    final double currentMaxPrice = currentFilterParams.maxPrice ?? 5000; // قيمة افتراضية قصوى
    const double maxPriceLimit = 10000; // الحد الأقصى للنطاق في الواجهة

    RangeValues currentRangeValues = RangeValues(currentMinPrice, currentMaxPrice);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price Range', style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
        Text(
          '\$${currentRangeValues.start.round()} - \$${currentRangeValues.end.round()} / month',
          style: GoogleFonts.lato(fontSize: 14, color: AppColors.taupe),
        ),
        RangeSlider(
          values: currentRangeValues,
          min: 0,
          max: maxPriceLimit,
          divisions: (maxPriceLimit / 100).round(), // للتحكم في دقة المؤشر
          activeColor: AppColors.charcoal,
          inactiveColor: AppColors.oat,
          labels: RangeLabels(
            currentRangeValues.start.round().toString(),
            currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues newValues) {
            context.read<FilterCubit>().onPriceRangeChanged(newValues.start, newValues.end);
          },
        ),
      ],
    );
  }

  Widget _buildRoomsSelection(BuildContext context, FilterParams currentFilterParams) {
    List<int?> roomOptions = [null, 1, 2, 3, 4]; // null لـ 'Any', 4 لـ '4+'
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rooms', style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: roomOptions.map((rooms) {
            final isSelected = currentFilterParams.minRooms == rooms;
            return ChoiceChip(
              label: Text(rooms == null ? 'Any' : (rooms == 4 ? '4+' : rooms.toString())),
              selected: isSelected,
              selectedColor: AppColors.charcoal,
              backgroundColor: AppColors.oat.withValues(alpha: 0.4),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.charcoal,
                fontWeight: FontWeight.bold,
              ),
              onSelected: (selected) {
                context.read<FilterCubit>().onRoomsSelected(selected ? rooms : null);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSelection(
      BuildContext context,
      List<AmenityModel> allAmenities,
      FilterParams currentFilterParams,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Features', style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3, // تعديل حسب الحاجة
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: allAmenities.length,
          itemBuilder: (context, index) {
            final amenity = allAmenities[index];
            final isSelected = currentFilterParams.amenityIds?.contains(amenity.id) ?? false;
            return FilterChip(
              label: Text(amenity.name),
              selected: isSelected,
              onSelected: (bool selected) {
                context.read<FilterCubit>().onAmenityToggled(amenity, selected);
              },
              selectedColor: AppColors.charcoal,
              backgroundColor: AppColors.oat.withValues(alpha: 0.4),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.charcoal,
                fontWeight: FontWeight.bold,
              ),
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? AppColors.charcoal : AppColors.taupe.withValues(alpha:0.5),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          // نرجع الـ FilterParams المطبقة إلى الشاشة السابقة
          Navigator.of(context).pop(context.read<FilterCubit>().getAppliedFilterParams);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.charcoal,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'applyFilters',
          style: GoogleFonts.lato(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
