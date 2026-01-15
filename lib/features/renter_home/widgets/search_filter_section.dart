import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';

class SearchFilterSection extends StatelessWidget {
  final VoidCallback? onFilterTap;
  final Function(String)? onSearchSubmit; // للبحث عند الضغط على Enter
  final VoidCallback? onSearchTap; // للذهاب إلى شاشة بحث منفصلة عند الضغط على شريط البحث
  final String? initialSearchQuery; // لقيمة البحث الأولية

  const SearchFilterSection({
    super.key,
    this.onFilterTap,
    this.onSearchSubmit,
    this.onSearchTap,
    this.initialSearchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onSearchTap, // عند النقر على شريط البحث، ننتقل إلى شاشة البحث
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.oat.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: AbsorbPointer( // لجعل TextField غير قابل للتركيز مباشرة
                absorbing: onSearchTap != null,
                child: TextField(
                  readOnly: onSearchTap != null, // جعل حقل النص للقراءة فقط إذا كان هناك onSearchTap
                  controller: TextEditingController(text: initialSearchQuery), // لعرض قيمة البحث الأولية
                  onSubmitted: onSearchSubmit,
                  decoration: InputDecoration(
                    hintText: AppStrings.tenantSearchHint,
                    hintStyle: GoogleFonts.lato(
                      color: Colors.grey.shade600,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.charcoal,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onFilterTap, // عند النقر على زر الفلتر
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.tune,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
