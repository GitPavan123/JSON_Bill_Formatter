import 'package:flutter/material.dart';

import 'hotel_parser/mainui.dart';
import 'json_formatter/image_input.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  List<Widget> body = const [ImageInput(), Mainui()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), label: "Format Bill"),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood), label: "Find Hotel"),
        ],
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
