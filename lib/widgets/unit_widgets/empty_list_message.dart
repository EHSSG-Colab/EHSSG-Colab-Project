import 'package:flutter/material.dart';

class EmptyListMessage extends StatelessWidget {
  final String message;
  final IconData icon;
  final String actionMessage;

  const EmptyListMessage({
    super.key,
    required this.message,
    required this.icon,
    required this.actionMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 150,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(71, 158, 158, 158),
                  blurRadius: 10.0,
                  offset: Offset(0.0, 5.0),
                ),
              ],
              color: const Color.fromARGB(73, 0, 0, 0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Icon(
              icon,
              size: 150,
              color: const Color.fromARGB(65, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: const TextStyle(color: Colors.black),
                    text: '$message\n',
                  ),
                  TextSpan(
                    style: const TextStyle(color: Colors.black),
                    text: actionMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
