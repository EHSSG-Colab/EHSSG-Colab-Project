import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/screens/home.dart';
import 'package:malaria_case_report_01/screens/info.dart';
import 'package:malaria_case_report_01/screens/profile_detail.dart';
import 'package:malaria_case_report_01/themes/app_icons.dart';
import 'package:malaria_case_report_01/themes/app_theme.dart';

import '../../screens/volunteers.dart';

class NavWrapper extends StatefulWidget {
  // Navigation wrapper is like an array. It starts with 0. The first item of the navigation menu will have an index of 0, the second and index of 1, etc.
  // By default, the index page as well as the landing page of the navigation wrapper is going to be the first page. Its index would be 0.
  final int initialIndex;
  const NavWrapper({super.key, this.initialIndex = 0});

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  // selectedIndex is the value selected by the user. When the user press a menu item, its index value will be stored here.
  // Since the user is not pressing any menu item when the page loads, the selectedIndex is initially 0.
  int _selectedIndex = 0;

  // This method updates the selectedIndex value based on the user activity
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // the initState method called on page load by default

  @override
  void initState() {
    super.initState();
    // redirect to specific page if provided
    _selectedIndex = widget.initialIndex;
  }

  // list of pages to be added under navigation menu items
  final List<Widget> _pages = [
    const Home(),
    const ProfileDetail(),
    const Volunteers(), // Fixed typo from 'Volunters' to 'Volunteers'
    const Info(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The nav wrapper is just a scoffold with bottom navigation bar.
      /**
       * Instead of creating a scaffold and navigation bar for every page in our application,
       * we can just create a scaffold and navigation bar once and use it for all pages.
       */
      /** The body of the scaffold will be a page widget.
       * If the user press the first navigation item, array index of 0 will be passed resuling in _pages[0] which is Home page.
       */
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _selectedIndex, // currentIndex is the index of the selected item.
        onTap:
            _onItemTapped, // onTap is the method that will be called when the user press a navigation item.
        /**
         * type is the type of the navigation bar. fixed is the type of the navigation bar that will always show the labels.
         * other types are shifting and scrolling.
         * shifting is the type of the navigation bar that will show the labels when the user press the item.
         * srcolling is the type of the navigation bar that will show the labels when the user scroll the page.
         */
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme().secondaryColor(),
        unselectedItemColor: AppTheme().highlightColor(),
        showUnselectedLabels: true,
        /**
         * Each child item of the bottom navigation bar is an object of BottomNavigationBarItem.
         */
        items: <BottomNavigationBarItem>[
          //home menu item
          BottomNavigationBarItem(
            icon:
                _selectedIndex == 0
                    ? AppIcons().homeFilledIcon()
                    : AppIcons().homeOutlineIcon(),
            label: 'Home',
          ),

          //profile menu item
          BottomNavigationBarItem(
            icon:
                _selectedIndex == 1
                    ? AppIcons().profileFilledIcon()
                    : AppIcons().profileOutlineIcon(),
            label: 'Profile',
          ),

          //volunteer menu item
          BottomNavigationBarItem(
            icon:
                _selectedIndex == 2
                    ? AppIcons().volunteerFilledIcon()
                    : AppIcons().volunteerOutlineIcon(),
            label: 'Volunteer',
          ),

          //info menu item
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
