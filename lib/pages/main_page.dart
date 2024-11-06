// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:capstone/pages/home_page.dart';
import 'package:capstone/pages/scanresult_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [Scanresult_Page(), Home_Page()];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(
              icon: Icon(
                Icons.bluetooth_searching,
                color: Colors.black,
              ),
              label: "Home"),
          NavigationDestination(
            icon: Icon(
              Icons.devices_rounded,
              color: Colors.black,
            ),
            label: "My Devices",
          )
        ],
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedIndex: _currentIndex,
      ),
      appBar: AppBar(
        title: Center(
          child: Text(
            _currentIndex == 0 ? "Home" : "My Devices",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
          ),
        ),
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
      ),
      body: _pages[_currentIndex],
    );
  }
}
