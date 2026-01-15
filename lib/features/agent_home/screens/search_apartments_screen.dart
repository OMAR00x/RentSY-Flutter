import 'package:flutter/material.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';




class SearchApartmentsScreen extends StatefulWidget {
  const SearchApartmentsScreen({super.key});

  @override
  State<SearchApartmentsScreen> createState() => _SearchApartmentsScreenState();
}

class _SearchApartmentsScreenState extends State<SearchApartmentsScreen> {
  final TextEditingController _controller = TextEditingController();

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    // ✨ سيتم استدعاء الـ Cubit هنا لتنفيذ البحث
    debugPrint("Searching for: $query");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oat,
      appBar: AppBar(
        backgroundColor: AppColors.oat,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.charcoal),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          cursorColor: AppColors.taupe,
          style: const TextStyle(color: AppColors.charcoal, fontSize: 16),
          decoration: InputDecoration(
            hintText: AppStrings.searchApartmentHint,
            hintStyle: const TextStyle(color: AppColors.taupe),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: AppColors.taupe),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: AppColors.taupe, size: 20),
              onPressed: () => _controller.clear(),
            )
          ),
          onSubmitted: _performSearch,
        ),
      ),
      // ✨ سيتم تبديل هذه الواجهة بنتائج البحث من الـ Cubit
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.search, color: AppColors.taupe, size: 52),
              SizedBox(height: 16),
              Text(
                AppStrings.searchPlaceholder,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.taupe, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
