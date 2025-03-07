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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
