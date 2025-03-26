import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/screens/home.dart';
import 'package:malaria_case_report_01/screens/info.dart';
import 'package:malaria_case_report_01/screens/profile_detail.dart';
import 'package:malaria_case_report_01/screens/volunteers.dart';
import 'package:malaria_case_report_01/themes/app_icons.dart';
import 'package:malaria_case_report_01/themes/app_theme.dart';

class NavWrapper extends StatefulWidget {
  final int initialIndex;
  const NavWrapper({super.key, this.initialIndex = 0});

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  @override
  void initState() {
    super.initState();

    // redirect to specific page if provided
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [Home(), ProfileDetail(), Volunteers(), Info()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme().secondaryColor(),
        unselectedItemColor: AppTheme().highlightColor(),
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          // home menu item
          BottomNavigationBarItem(
            icon:
                _selectedIndex == 0
                    ? AppIcons().homeFilledIcon()
                    : AppIcons().homeOutlineIcon(),
            label: 'Home',
          ),

          // profile menu item
          BottomNavigationBarItem(
            icon:
                _selectedIndex == 1
                    ? AppIcons().profileFilledIcon()
                    : AppIcons().profileOutlineIcon(),
            label: 'Profile',
          ),

          // volunteer menu item
          BottomNavigationBarItem(
            icon:
                _selectedIndex == 2
                    ? AppIcons().volunteerFilledIcon()
                    : AppIcons().volunteerOutlineIcon(),
            label: 'Volunteer',
          ),

          // info menu item
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
