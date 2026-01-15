// lib/features/agent_home/screens/apartment_details_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/constants/api_constants.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/core/domain/models/apartment_model.dart';
import 'package:saved/core/widgets/loading_widget.dart';
import 'package:saved/features/agent_home/cubit/my_apartments_cubit.dart';

class AgentApartmentDetailsScreen extends StatelessWidget {
  final ApartmentModel apartment;

  const AgentApartmentDetailsScreen({super.key, required this.apartment});

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "${apartment.title}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
                context.read<MyApartmentsCubit>().deleteApartment(apartment.id).then((_) {
                  if (Navigator.of(context).canPop()) {
                    // إرجاع true لإعلام الواجهة السابقة بنجاح الحذف
                    Navigator.of(context).pop(true);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oat,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.charcoal,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text("My Apartment Details", style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () => _showDeleteConfirmation(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageGallery(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      _buildDivider(),
                      
                      // --- ✨ 1. عرض الوصف فقط إذا كان موجوداً ---
                      if (apartment.description.isNotEmpty) ...[
                        _buildSectionTitle('About this place'),
                        Text(apartment.description, style: const TextStyle(fontSize: 15, color: AppColors.mocha, height: 1.5)),
                         _buildDivider(),
                      ],
                      
                      _buildSectionTitle('Details'),
                      // --- ✨ 2. عرض عدد الغرف فقط إذا كان موجوداً ---
                      if (apartment.rooms > 0)
                        _buildInfoCard("Rooms", apartment.rooms.toString(), Icons.bed_outlined),
                      
                      _buildInfoCard("Status", apartment.status, Icons.check_circle_outline, valueColor: apartment.status == 'active' ? Colors.green.shade700 : Colors.orange.shade700),
                      
                      // --- ✨ 3. عرض المدينة فقط إذا كان اسمها موجوداً ---
                      if (apartment.city.name.isNotEmpty && apartment.city.name != 'Unknown')
                        _buildInfoCard("City", apartment.city.name, Icons.location_city_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(apartment.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
        const SizedBox(height: 8),
        if (apartment.address.isNotEmpty)
          Text(apartment.address, style: const TextStyle(fontSize: 15, color: AppColors.taupe)),
        const SizedBox(height: 12),
        Text('${apartment.price.toStringAsFixed(2)} / ${apartment.priceType}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.mocha)),
      ],
    );
  }

  Widget _buildImageGallery() {
    if (apartment.images.isEmpty) {
      return Container(
        color: Colors.grey.shade400,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported_outlined, color: Colors.white, size: 60),
              SizedBox(height: 8),
              Text('No Images Available', style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      );
    }
    return PageView.builder(
      itemCount: apartment.images.length,
      itemBuilder: (_, index) {
        return CachedNetworkImage(
          imageUrl: getFullImageUrl(apartment.images[index].url),
          fit: BoxFit.cover,
          placeholder: (context, url) => const LoadingWidget(),
          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error, color: Colors.white, size: 50)),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.charcoal)),
    );
  }
  
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Divider(color: AppColors.taupe, thickness: 0.5),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, {Color? valueColor}) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.taupe.withValues(alpha:0.2),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.mocha),
        title: Text(label),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: valueColor)),
      ),
    );
  }
}
