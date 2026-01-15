import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saved/constants/api_constants.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/domain/models/user.dart';
import 'package:saved/core/widgets/loading_widget.dart'; // ✨ تم استخدام الويدجت الخاصة بك
import 'package:saved/features/profile/cubit/profile_cubit.dart';
import 'package:saved/features/profile/cubit/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _passwordController;
  File? _selectedImage;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submit() {
    context.read<ProfileCubit>().updateProfile(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
          avatar: _selectedImage,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oat,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.charcoal),
        title: const Text(AppStrings.editProfileTitle, style: TextStyle(color: AppColors.charcoal)),
        centerTitle: true,
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
         state.whenOrNull(
            // عند نجاح التحديث
            updateSuccess: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile Updated Successfully!'), backgroundColor: Colors.green),
              );
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            updateFailure: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red),
              );
            },
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (widget.user.avatar != null
                              ? NetworkImage(getFullImageUrl(widget.user.avatar!.url))
                              : const AssetImage('assets/images/avatar.jpg')) as ImageProvider,
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: AppColors.charcoal, shape: BoxShape.circle),
                      child: const Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(AppStrings.updateProfilePhoto, style: TextStyle(color: AppColors.mocha)),
              const SizedBox(height: 30),
              
              _label(AppStrings.firstName),
              _inputField(controller: _firstNameController, hint: 'Yomna'),
              const SizedBox(height: 16),
              
              _label(AppStrings.lastName),
              _inputField(controller: _lastNameController, hint: 'Majzoub'),
              const SizedBox(height: 16),
              
              _label(AppStrings.password),
              _inputField(
                controller: _passwordController,
                hint: AppStrings.passwordHint,
                obscure: obscurePassword,
                suffix: IconButton(
                  icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
                  onPressed: () => setState(() => obscurePassword = !obscurePassword),
                ),
              ),
              const SizedBox(height: 40),
              
              // ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨
              // ✨            الحل النهائي هنا            ✨
              // ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  // استخدام mapOrNull للتحقق من الحالة بطريقة آمنة
                  return state.mapOrNull(
                    // في حالة "جاري التحديث"، نعرض الويدجت الخاصة بك
                    updateInProgress: (_) => const LoadingWidget(),
                  ) ?? // '??' تعني: إذا كانت الحالة أي شيء آخر، اعرض ما يلي
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.charcoal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(AppStrings.saveChanges, style: TextStyle(fontSize: 16)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(text, style: const TextStyle(color: AppColors.charcoal, fontSize: 14, fontWeight: FontWeight.bold)),
        ),
      );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.milk,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }
}
