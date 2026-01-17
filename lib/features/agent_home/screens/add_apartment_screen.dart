
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/domain/models/amenity_model.dart';
import 'package:saved/core/domain/models/city_model.dart';
import 'package:saved/features/agent_home/cubit/add_apartment_cubit.dart';
import 'package:saved/features/agent_home/cubit/add_apartment_state.dart';
import 'package:saved/features/agent_home/cubit/apartment_form_cubit.dart';
import 'package:saved/features/agent_home/cubit/apartment_form_state.dart';
import 'package:saved/core/domain/models/area_model.dart';

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  @override
  void initState() {
    super.initState();
   
    context.read<ApartmentFormCubit>().fetchFormData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oat,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.charcoal),
        title: const Text(AppStrings.addApartmentTitle, style: TextStyle(color: AppColors.charcoal)),
        centerTitle: true,
      ),
      
      body: BlocBuilder<ApartmentFormCubit, ApartmentFormState>(
        builder: (context, formState) {
          return formState.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $message'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ApartmentFormCubit>().fetchFormData(),
                    child: const Text('Retry'),
                  )
                ],
              ),
            ),
           
            success: (cities, amenities, areas, isLoadingAreas) {
              return _AddApartmentForm(
                availableCities: cities,
                availableAmenities: amenities,
                availableAreas: areas,
                isLoadingAreas: isLoadingAreas,
              );
            },
          );
        },
      ),
    );
  }
}


class _AddApartmentForm extends StatefulWidget {
  final List<CityModel> availableCities;
  final List<AmenityModel> availableAmenities;
  final List<AreaModel> availableAreas;
  final bool isLoadingAreas;


  const _AddApartmentForm({
    required this.availableCities,
    required this.availableAmenities,
     required this.availableAreas,
    required this.isLoadingAreas,
  });

  @override
  State<_AddApartmentForm> createState() => _AddApartmentFormState();
}

class _AddApartmentFormState extends State<_AddApartmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  
  final List<XFile> _selectedImages = [];
  int _rooms = 1;
  CityModel? _selectedCity;
   AreaModel? _selectedArea; 
  final List<int> _selectedAmenities = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await ImagePicker().pickMultiImage(imageQuality: 80);
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(pickedFiles);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking images: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      _showErrorSnackBar('Please select at least one image.');
      return;
    }
    if (_selectedCity == null) {
      _showErrorSnackBar('Please select a city.');
      return;
    }
    if (_selectedArea == null) {
      _showErrorSnackBar('Please select an area.');
      return;
    }
    
    context.read<AddApartmentCubit>().submitApartment(
      title: _titleController.text,
      description: _descriptionController.text,
      price: _priceController.text,
      rooms: _rooms,
      address: _addressController.text,
      cityId: _selectedCity!.id,
      areaId:  _selectedArea!.id, 
      amenities: _selectedAmenities,
      images: _selectedImages,
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddApartmentCubit, AddApartmentState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (apartment) {
            Navigator.of(context).pop(true);
          },
          error: (message) => _showErrorSnackBar(message),
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return IgnorePointer(
          ignoring: isLoading,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(AppStrings.apartmentNameLabel),
                  TextFormField(
                    controller: _titleController,
                    decoration: _buildInputDecoration(hint: AppStrings.apartmentNameHint),
                    validator: (v) => v!.isEmpty ? 'Title is required' : null,
                  ),
                  
                  _buildLabel(AppStrings.descriptionLabel),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: _buildInputDecoration(hint: AppStrings.descriptionHint),
                    maxLines: 3,
                    validator: (v) => v!.isEmpty ? 'Description is required' : null,
                  ),

                  
                  _buildLabel('City'),
                  DropdownButtonFormField<CityModel>(
                    initialValue: _selectedCity,
                    decoration: _buildInputDecoration(hint: 'Select a city'),
                    items: widget.availableCities.map((city) {
                      return DropdownMenuItem(value: city, child: Text(city.name));
                    }).toList(),
                    onChanged: (city) {
                      setState(() { 
                        _selectedCity = city; 
                        _selectedArea = null;
                      });
                      if (city != null) {
                       
                        context.read<ApartmentFormCubit>().fetchAreasForCity(city.id);
                      }
                    },
                    validator: (v) => v == null ? 'City is required' : null,
                  ),
                   _buildLabel('Area'),
                  if (_selectedCity == null)
                    _buildDisabledDropdown('Select a city first'),

                  if (_selectedCity != null && widget.isLoadingAreas)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  if (_selectedCity != null && !widget.isLoadingAreas)
                    DropdownButtonFormField<AreaModel>(
                      initialValue: _selectedArea,
                      decoration: _buildInputDecoration(hint: 'Select an area'),
                      hint: widget.availableAreas.isEmpty ? const Text('No areas found') : const Text('Select an area'),
                      items: widget.availableAreas.map((area) {
                        return DropdownMenuItem(value: area, child: Text(area.name));
                      }).toList(),
                      onChanged: widget.availableAreas.isEmpty ? null : (area) {
                        setState(() { _selectedArea = area; });
                      },
                      validator: (v) => v == null ? 'Area is required' : null,
                    ),

                  _buildLabel(AppStrings.addressLabel),
                  TextFormField(
                    controller: _addressController,
                    decoration: _buildInputDecoration(hint: AppStrings.addressHint, suffix: const Icon(Icons.location_on_outlined)),
                    validator: (v) => v!.isEmpty ? 'Address is required' : null,
                  ),

                  const SizedBox(height: 16),
                  _buildCard(
                    child: Row(
                      children: [
                        const Icon(Icons.bed_outlined, color: AppColors.taupe),
                        const SizedBox(width: 10),
                        const Expanded(child: Text(AppStrings.numRoomsLabel)),
                        _buildCounterButton(Icons.remove, () {
                          if (_rooms > 1) setState(() => _rooms--);
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(_rooms.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        _buildCounterButton(Icons.add, () => setState(() => _rooms++)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  _buildCard(
                    child: Row(
                      children: [
                        const Icon(Icons.attach_money, color: AppColors.taupe),
                        const SizedBox(width: 10),
                        const Expanded(child: Text(AppStrings.pricePerNightLabel)),
                        SizedBox(
                          width: 120,
                          child: TextFormField(
                            controller: _priceController,
                            decoration: _buildInputDecoration(hint: AppStrings.priceHint, suffixText: 'USD'),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  
                  _buildLabel(AppStrings.featuresLabel),
                  Wrap(
                    spacing: 8,
                    children: widget.availableAmenities.map((amenity) {
                      final isSelected = _selectedAmenities.contains(amenity.id);
                      return FilterChip(
                        label: Text(amenity.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedAmenities.add(amenity.id);
                            } else {
                              _selectedAmenities.remove(amenity.id);
                            }
                          });
                        },
                        selectedColor: AppColors.charcoal,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        checkmarkColor: Colors.white,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),
                  _buildLabel(AppStrings.addPhotosLabel),
                  GestureDetector(
                    onTap: isLoading ? null : _pickImages,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 50, color: AppColors.taupe),
                          SizedBox(height: 8),
                          Text('Tap to upload images'),
                        ],
                      ),
                    ),
                  ),
                  
                  if (_selectedImages.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return _buildImagePreview(_selectedImages[index], index);
                        },
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.charcoal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(AppStrings.saveListing, style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
  
  InputDecoration _buildInputDecoration({required String hint, Widget? suffix, String? suffixText}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffix,
      suffixText: suffixText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
  Widget _buildDisabledDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300)
      ),
      child: Row(
        children: [
          Text(hint, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: child,
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.grey.shade200,
      shape: const CircleBorder(),
      child: InkWell(onTap: onTap, customBorder: const CircleBorder(), child: Padding(padding: const EdgeInsets.all(6.0), child: Icon(icon, size: 20))),
    );
  }
  
  Widget _buildImagePreview(XFile imageFile, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(imageFile.path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.black.withValues(alpha:0.6),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close, color: Colors.white, size: 12),
                onPressed: () => _removeImage(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
