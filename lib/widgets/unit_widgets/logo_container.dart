import 'package:flutter/material.dart';

class LogoContainer extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final String imagePath;

  const LogoContainer({
    super.key,
    this.width = 100.0,
    this.height = 100.0,
    this.padding = const EdgeInsets.all(10),
    this.imagePath = 'assets/images/logo.png',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.topCenter,
      padding: padding,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(71, 158, 158, 158),
            blurRadius: 10.0,
            offset: Offset(0.0, 5.0),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Image.asset(imagePath),
    );
  }
}
