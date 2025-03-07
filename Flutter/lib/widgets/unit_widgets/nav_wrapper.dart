import 'package:flutter/material.dart';

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
  void _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
