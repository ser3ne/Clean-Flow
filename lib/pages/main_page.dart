// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'dart:convert';
import 'dart:io';

import 'package:capstone/Widgets/notice_button.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/pages/historical_devices_page.dart';
import 'package:capstone/pages/home_page.dart';
import 'package:capstone/pages/scanresult_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.args});
  final HistoricalArguments args;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<dynamic> historicalData = [];
  Future<void> _loadHistoricalData() async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString('historicalData');
    if (jsonString != null) {
      setState(() {
        historicalData = jsonDecode(jsonString);
      });
    }
  }

  int _currentIndex = 0;
  late String name;
  late List<Widget> pages = [
    Home_Page(),
    Scanresult_Page(),
    HistoricalDevicesPage(
      deviceName: name,
    )
  ];

  String appBartText(int currentPage) {
    String? barText;
    switch (currentPage) {
      case 0:
        setState(() {
          barText = "Home";
        });
        break;
      case 1:
        setState(() {
          barText = "Scan";
        });
        break;
      case 2:
        setState(() {
          barText = "History";
        });
        break;
      default:
        break;
    }
    return barText!;
  }

  Future<void> dataAlert() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: double.infinity,
          height: 85, //65
          // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Colors.blueAccent),
          child: Center(
            child: Icon(
              Icons.save,
              color: Colors.black,
              size: 40,
            ),
          ),
        ),
        content: SizedBox(
          height: 250, //147
          child: Column(
            children: const [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "How to save your data",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    "Unsaved data will be lost.\nPlease press the disconnect button and confirm disconnection to save your data",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    "NOTE:",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                ),
              ),
              Icon(Icons.bluetooth_disabled_rounded),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    "The quick disconnect button does not save data.",
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: MaterialButton(
                color: Colors.lightBlue,
                onPressed: () {
                  Navigator.pop(context); //closes the pop-up
                },
                child: Text("Got It")),
          ),
        ],
      ),
    );
  }

  void initiateDataAlert() {
    dataAlert();
  }

  @override
  void initState() {
    super.initState();
    name = widget.args.deviceName;
    _loadHistoricalData().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (historicalData.isEmpty) {
          initiateDataAlert();
        } else {
          _showSnackBar();
        }
      });
    });
  }

  void _showSnackBar() {
    String reductionPercentage = _getLatestPercentage();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          "You have reduced $reductionPercentage of dirty electricity in your last session!"),
      onVisible: () {
        Future.delayed(const Duration(milliseconds: 3000), () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        });
      },
    ));
  }

  String _getLatestPercentage() {
    if (historicalData.isEmpty) {
      return "0%";
    }

    final lastSession = historicalData.last;

    final perc = lastSession['perc'];
    if (perc != null) {
      return "$perc%";
    } else {
      return "0%";
    }
  }

  void shouldPop(bool didPop) async {
    {
      if (!didPop) {
        bool willPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            titlePadding: EdgeInsets.zero,
            title: Container(
              width: double.infinity,
              height: 60,
              // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: Colors.red),
              child: Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 50,
                ),
              ),
            ),
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Exit App",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Would you like to exit the app?",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              MaterialButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop(false); //prevent app closure
                  },
                  child: Text(
                    "No",
                    style: TextStyle(color: Colors.black),
                  )),
              SizedBox(
                width: 60,
              ),
              //Yes
              MaterialButton(
                  color: Colors.redAccent,
                  onPressed: () async {
                    Navigator.of(context).pop(true); //enable app closure
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ))
              //No
            ],
          ),
        );
        if (willPop) {
          //close the app
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
            ),
            NavigationDestination(
              icon: Icon(
                Icons.devices,
                color: Colors.black,
              ),
              label: "History",
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
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image(image: AssetImage("assets/cf.png")),
          ),
          centerTitle: true,
          title: Text(
            appBartText(_currentIndex),
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.w900),
          ),
          // Button for the notice/alert of saving historical data
          actions: [
            NoticeButton(),
            SizedBox(
              width: 20,
            )
          ],
          backgroundColor: colorY,
        ),
        body: pages[_currentIndex],
      ),
    );
  }
}
