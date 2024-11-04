// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:capstone/Widgets/custom_text.dart';
import 'package:capstone/pages/device_overview.dart';
import 'package:capstone/global/args.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => Home_StatePage();
}

class Home_StatePage extends State<Home_Page> {
  Future<void> _refresh() async {
    return Future.delayed(Duration(milliseconds: 700));
  }

  Future<void> initPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    initPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: SizedBox(
                child: Text(
                  "My Devices",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            SizedBox(
              child: connectedDevices.isEmpty
                  ?
                  //true
                  Center(child: Text("BLA BLA"))
                  //false
                  : Text("COnnected blabla"),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.60,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 200, 200, 200),
                    borderRadius: BorderRadius.circular(20)),
                child: ListView.builder(
                  itemCount:
                      connectedDevices.isEmpty ? 1 : connectedDevices.length,
                  itemBuilder: (context, index) {
                    return connectedDevices.isEmpty
                        //Sets "No Device" text if there aren't any
                        ? Padding(
                            padding: const EdgeInsets.only(top: 235),
                            child: Center(
                                child: CustomText(
                                    text: "No Devices",
                                    size: 30,
                                    fontWeight: FontWeight.w900)),
                          )
                        //Takes from Connected Devices if any
                        //This will build all devices "CURRENTLY" connected
                        : DeviceOverview(
                            device: connectedDevices[index],
                            platformName: connectedDevices[index].platformName,
                            size: 20,
                          );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
