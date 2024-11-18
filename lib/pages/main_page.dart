// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:capstone/global/args.dart';
import 'package:capstone/pages/home_page.dart';
import 'package:capstone/pages/scanresult_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  List<Widget> pages = [Home_Page(), Scanresult_Page()];
  void shouldPop(bool didPop) async {
    {
      if (!didPop) {
        bool willPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Confirm Navigation"),
            content: Text("Are you sure you want to exit?"),
            actions: [
              // No Option
              MaterialButton(
                color: Colors.lightBlue,
                onPressed: () {
                  // Prevent Closure
                  Navigator.of(context).pop(false);
                },
                child: Text("No"),
              ),
              SizedBox(width: 60),
              // Yes Option
              MaterialButton(
                color: Colors.lightBlue,
                onPressed: () async {
                  Navigator.of(context).pop(true); // Enable Closure
                },
                child: Text("Yes", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
        if (willPop) {
          exit(0);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: shouldPop,
      child: Scaffold(
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
      ),
    );
  }
}
