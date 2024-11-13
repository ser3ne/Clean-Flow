// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:capstone/global/args.dart';
import 'package:capstone/pages/home_page.dart';
import 'package:capstone/pages/scanresult_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }

  int _currentIndex = 0;
  List<Widget> pages = [Home_Page(), Scanresult_Page()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.black,
              ),
              label: "Home"),
          NavigationDestination(
            icon: Icon(
              Icons.bluetooth_searching,
              color: Colors.black,
            ),
            label: "Scan",
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
        leading: Image(image: AssetImage("assets/cf.png")),
        centerTitle: true,
        title: Text(
          _currentIndex == 0 ? "Home" : "My Devices",
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w900),
        ),
        backgroundColor: colorY,
      ),
      body: pages[_currentIndex],
    );
  }
}
