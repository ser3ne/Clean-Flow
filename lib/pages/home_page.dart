// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:ffi';

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
  Color color_1 = Color.fromRGBO(255, 255, 255, 1);
  Color color_2 = Color.fromRGBO(194, 193, 216, 1);
  Color color_3 = Color.fromRGBO(140, 138, 184, 1);
  Color color_4 = Color.fromRGBO(83, 80, 139, 1);
  Color color_5 = Color.fromRGBO(54, 50, 124, 1);
  Color color_6 = Color.fromRGBO(18, 15, 69, 1);
  Color color_7 = Color.fromRGBO(0, 0, 0, 1);
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
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 0,
                color: Color.fromARGB(0, 255, 255, 255),
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
            gradient: LinearGradient(
              colors: [
                color_1,
                color_2,
                color_3,
                color_4,
                color_5,
                color_6,
                color_7
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                height: 30,
                child: Text(
                  "Connected Devices",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            //Dapat Dito sa sizedbox lalabas ung connected Device hindi sa Container
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child:
                  //connectedDevices.isEmpty
                  true
                      ?
                      //true
                      FloatingActionButton(
                          onPressed: () {
                            print("tapped");
                          },
                          child: Text("Lorem Ipsum"),
                        )
                      //false
                      : Text(
                          "No currently Connected Device",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
            ),
            SizedBox(
              height: 20,
              child: Text(
                "Saved Devices",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.60,
                decoration: BoxDecoration(
                    color: Color.fromARGB(55, 255, 255, 255),
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
                          );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
