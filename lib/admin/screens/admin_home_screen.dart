import 'package:flutter/material.dart';
import "package:movie_ticket_booking/auth/auth_service.dart";

import '../../constants/color.dart';
import "../widgets/bottom_navbar.dart";
import "movies/movie_screen.dart";
import "theatre_screen/theatre_screen.dart";
import "shows_screen/show_screen.dart";

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _getSelectedScreen(),
      bottomNavigationBar: BottomNavbar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getPageTitle(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Admin Panel',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: InkWell(
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Text(
                'A',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () => AuthService.signOut(),
          )
        ),
      ],
    );
  }

  String _getPageTitle() {
    const titles = ['Movies', 'Theatres', 'Shows'];
    return titles[_selectedIndex];
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const MovieScreen();
      case 1:
        return const TheatreScreen();
      case 2:
        return const ShowScreen();
      default:
        return MovieScreen();
    }
  }
}
