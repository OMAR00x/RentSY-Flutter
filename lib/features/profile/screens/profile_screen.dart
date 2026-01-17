import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saved/constants/api_constants.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/constants/app_strings.dart';
import 'package:saved/core/domain/models/user.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/core/widgets/loading_widget.dart';
import 'package:saved/features/auth/repository/auth_repository.dart';
import 'package:saved/features/profile/cubit/profile_cubit.dart';
import 'package:saved/features/profile/cubit/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedLanguage = 'En';
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedLanguage = context.locale.languageCode == 'ar' ? 'Ar' : 'En';
  }

  void _logout() {
    context.read<AuthRepository>().logout();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oat,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppStrings.profileTitle,
          style: TextStyle(color: AppColors.charcoal),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          state.mapOrNull(
            updateSuccess: (_) {
              context.read<ProfileCubit>().fetchProfile();
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const LoadingWidget(),
            loadInProgress: () => const LoadingWidget(),
            updateInProgress: () => const LoadingWidget(),
            loadFailure: (message) => _buildErrorState(context, message),
            updateFailure: (message) =>
                _buildErrorState(context, 'Update Failed: $message'),
            loadSuccess: (user) => _buildSuccessUI(context, user),
            updateSuccess: (updatedUser) =>
                _buildSuccessUI(context, updatedUser),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $message', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<ProfileCubit>().fetchProfile(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessUI(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: user.avatar != null
                ? NetworkImage(getFullImageUrl(user.avatar!.url))
                : const AssetImage('assets/images/avatar.jpg') as ImageProvider,
          ),
          const SizedBox(height: 12),
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10), 
          Container(
            
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.mocha.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.mocha,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Wallet: \$${user.walletBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mocha,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRouter.editProfile,
                arguments: user,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.charcoal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                AppStrings.editProfile,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          _profileTile(
            icon: Icons.language,
            title: AppStrings.language,
            trailing: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [_langButton('Ar'), _langButton('En')],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _profileTile(
            icon: Icons.dark_mode_outlined,
            title: AppStrings.theme,
            trailing: Switch(
              value: isDarkMode,
              onChanged: (val) => setState(() => isDarkMode = val),
              activeThumbColor: AppColors.mocha,
            ),
          ),
          const SizedBox(height: 12),
          _profileTile(
            icon: Icons.logout,
            title: AppStrings.logout,
            titleColor: Colors.red,
            onTap: _logout,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    Color titleColor = AppColors.charcoal,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.milk,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: titleColor),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _langButton(String text) {
    final bool isActive = selectedLanguage == text;
    return GestureDetector(
      onTap: () {
        setState(() => selectedLanguage = text);
        if (text == 'Ar') {
          context.setLocale(const Locale('ar'));
        } else {
          context.setLocale(const Locale('en'));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.mocha : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
