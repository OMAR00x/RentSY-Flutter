import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/core/widgets/loading_widget.dart';
import 'package:saved/features/register/cubit/register_cubit.dart';
import 'package:saved/features/register/cubit/register_state.dart';



import 'widgets/image_picker_field.dart';

class CreateYourAccountPage extends StatefulWidget {
  const CreateYourAccountPage({super.key});

  @override
  State<CreateYourAccountPage> createState() => _CreateYourAccountPageState();
}

class _CreateYourAccountPageState extends State<CreateYourAccountPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  XFile? _avatarImage;
  XFile? _idFrontImage;
  XFile? _idBackImage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.charcoal),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
       
      fillColor: AppColors.taupe.withValues(alpha: 0.25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Future<void> _pickImage(Function(XFile) onSelect) async {
    final picker = ImagePicker();
    final XFile? pic =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pic != null) {
      setState(() => onSelect(pic));
    }
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );

    if (pickedDate != null) {
      setState(() {
        _birthDateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_avatarImage == null ||
        _idFrontImage == null ||
        _idBackImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى اختيار كامل الصور المطلوبة'),
          backgroundColor: Colors.red[900],
        ),
      );
      return;
    }

    final role =
        ModalRoute.of(context)!.settings.arguments as String? ?? 'renter';

    context.read<RegisterCubit>().submitRegistration(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
          birthdate: _birthDateController.text,
          password: _passwordController.text,
          passwordConfirmation: _confirmPasswordController.text,
          role: role,
          avatar: _avatarImage!,
          idFront: _idFrontImage!,
          idBack: _idBackImage!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.milk,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.milk,
        iconTheme: const IconThemeData(color: AppColors.charcoal,weight:80),
        title: const Text(
          AppStrings.createYourAccount,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.charcoal,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (user) {
              Navigator.pushReplacementNamed(
                context,
                AppRouter.accountCreated,
                arguments: user,
              );
            },
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
          );
        },
        builder: (context, state) {
          final loading =
              state.maybeWhen(loading: () => true, orElse: () => false);

          return IgnorePointer(
            ignoring: loading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration:
                                _inputDecoration(label: "First Name"),
                            validator: (v) =>
                                v!.isEmpty ? "Required" : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration:
                                _inputDecoration(label: "Last Name"),
                            validator: (v) =>
                                v!.isEmpty ? "Required" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(
                        label: "Phone",
                        prefixIcon:
                            const Icon(Icons.phone_outlined),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _birthDateController,
                      readOnly: true,
                      onTap: _selectDate,
                    
                      decoration: _inputDecoration(
                        
                        label: "Birth Date",
                        suffixIcon:
                            const Icon(Icons.calendar_today_outlined),
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: _inputDecoration(
                        
                        label: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _isObscure = !_isObscure),
                        ),
                      ),
                      validator: (v) =>
                          v!.length < 8 ? "Min 8 characters" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration:
                          _inputDecoration(label: "Confirm Password"),
                      validator: (v) =>
                          v != _passwordController.text
                              ? "Passwords don't match"
                              : null,
                    ),
                    const SizedBox(height: 24),

                    ImagePickerField(
                      label: "Personal Photo",
                      image: _avatarImage,
                      onTap: () =>
                          _pickImage((f) => _avatarImage = f),
                    ),
                    const SizedBox(height: 16),

                    ImagePickerField(
                      label: "ID Front",
                      image: _idFrontImage,
                      onTap: () =>
                          _pickImage((f) => _idFrontImage = f),
                    ),
                    const SizedBox(height: 16),

                    ImagePickerField(
                      label: "ID Back",
                      image: _idBackImage,
                      onTap: () =>
                          _pickImage((f) => _idBackImage = f),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width:280,
                      height: 54,
                      child: ElevatedButton(
                        
                        onPressed: loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          shadowColor: AppColors.taupe,
                          elevation:5.9,
                          backgroundColor: AppColors.mocha,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: loading
                            ? const LoadingWidget()
                            : const Text(
                                "Create account",
                                style: TextStyle(
                                  color: AppColors.milk,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
