// lib/features/register/screens/widgets/image_picker_field.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';


class ImagePickerField extends StatelessWidget {
  final String label;
  final XFile? image;
  final VoidCallback onTap;

  const ImagePickerField({
    super.key,
    required this.label,
    this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          selectionColor: AppColors.mocha,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              
              color: AppColors.taupe.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.image_outlined,
                  color: AppColors.charcoal,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectionColor: AppColors.charcoal,
                    image?.name ?? AppStrings.noImageSelected,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: image != null
                          ? AppColors.charcoal
                          : AppColors.charcoal.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const Icon(
                  Icons.upload_outlined,
                  color: AppColors.charcoal,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
