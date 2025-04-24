import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/screens/home.dart';
import 'package:malaria_case_report_01/screens/info.dart';
import 'package:malaria_case_report_01/screens/profile_detail.dart';
import 'package:malaria_case_report_01/screens/volunteers.dart';
import 'package:malaria_case_report_01/themes/app_icons.dart';
import 'package:malaria_case_report_01/themes/app_theme.dart';

class NavWrapper extends StatefulWidget {
  // The navigation wrapper starts with an index of 0 by default.
  // The first item of the navigation menu will have an index of 0, the second an index of 1, etc.
  final int initialIndex;

  const NavWrapper({super.key, this.initialIndex = 0});

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  // The selected index is the value selected by the user.
  // When the user presses a menu item, its index value will be stored here.
  int _selectedIndex = 0;

  // This method updates the selected index value based on user activity.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Redirect to a specific page if an initial index is provided.
    _selectedIndex = widget.initialIndex;
  }

  // List of pages to be added under navigation menu items.
  final List<Widget> _pages = [Home(), ProfileDetail(), Volunteers(), Info()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The nav wrapper is a scaffold with a bottom navigation bar.
      /**
       * Instead of creating a scaffold and navigation bar for every page in our application,
       * we can create a scaffold and navigation bar once and use it for all pages.
       */
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // The index of the selected item.
        onTap: _onItemTapped, // Called when the user presses a navigation item.
        type: BottomNavigationBarType.fixed, // Always show labels.
        selectedItemColor: AppTheme().secondaryColor(),
        unselectedItemColor: AppTheme().highlightColor(),
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          // Home menu item
          BottomNavigationBarItem(
            icon:
                _selectedIndex == 0
                    ? AppIcons().homeFilledIcon()
                    : AppIcons().homeOutlineIcon(),
            label: 'Home',
          ),

          // Profile menu item
          BottomNavigationBarItem(
            icon:
                _selectedIndex == 1
                    ? AppIcons().profileFilledIcon()
                    : AppIcons().profileOutlineIcon(),
            label: 'Profile',
          ),

          // Volunteer menu item
          BottomNavigationBarItem(
            icon:
                _selectedIndex == 2
                    ? AppIcons().volunteerFilledIcon()
                    : AppIcons().volunteerOutlineIcon(),
            label: 'Volunteer',
          ),

          // Info menu item
          BottomNavigationBarItem(
            icon:
                _selectedIndex == 3
                    ? AppIcons().infoFilledIcon()
                    : AppIcons().infoOutlineIcon(),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}
