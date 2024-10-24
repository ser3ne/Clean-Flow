// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:capstone/Widgets/device_overview.dart';
import 'package:flutter/material.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => Home_StatePage();
}

class Home_StatePage extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.70,
            // decoration: BoxDecoration(
            //     border: Border.all(
            //         style: BorderStyle.solid, color: Colors.black, width: 5)),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    DeviceOverview(),
                    DeviceOverview(),
                    DeviceOverview(),
                    DeviceOverview(),
                    DeviceOverview(),
                    DeviceOverview(),
                    DeviceOverview(),
                    DeviceOverview()
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 33, 150, 243),
              onPressed: () {},
              child: Text("Hey nigga"),
            ),
          )
        ],
      ),
    );
  }
}
