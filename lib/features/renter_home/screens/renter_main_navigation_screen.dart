import 'package:flutter/material.dart';
import 'package:saved/constants/app_colors.dart';
import 'package:saved/features/renter_home/screens/favorites_screen.dart';
import 'package:saved/features/renter_home/screens/my_bookings_screen.dart';
import 'package:saved/features/renter_home/screens/renter_home_screen.dart';

import '../../profile/screens/profile_screen.dart';

class RenterMainNavigationScreen extends StatefulWidget {
  const RenterMainNavigationScreen({super.key});

  @override
  State<RenterMainNavigationScreen> createState() =>
      _RenterMainNavigationScreenState();
}

class _RenterMainNavigationScreenState
    extends State<RenterMainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    RenterHomeScreen(),
    FavoritesScreen(),
   MyBookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.milk,
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        backgroundColor: AppColors.milk,
        elevation: 10,
        selectedItemColor: AppColors.charcoal,
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
           BottomNavigationBarItem(
            icon: Icon(Icons.favorite), // ✨ ممكن نخليها Icons.favorite لو حبينا
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'My Bookings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
