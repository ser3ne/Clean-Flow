// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:capstone/Widgets/custom_text.dart';
import 'package:capstone/pages/device_overview.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => Home_StatePage();
}

class Home_StatePage extends State<Home_Page> {
  Future<void> _refresh() async {
    return Future.delayed(Duration(milliseconds: 700));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.height * 0.70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.60,
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount:
                        connectedDevices.isEmpty ? 1 : connectedDevices.length,
                    itemBuilder: (context, index) {
                      return connectedDevices.isEmpty
                          ? Center(
                              child: CustomText(
                                  text: "No Devices",
                                  size: 15,
                                  fontWeight: FontWeight.w900))
                          : DeviceOverview(
                              device: connectedDevices[index],
                              platformName:
                                  connectedDevices[index].platformName);
                    },
                  ),
                )),
            SizedBox(
              height: 20,
              child: Text("Devices: ${connectedDevices.length}"),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Color.fromARGB(255, 33, 150, 243),
                onPressed: () async {
                  await Navigator.pushNamed(context, scanresult);
                  //Make the logic when you comeback
                },
                child: Text("Connect new Device"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
