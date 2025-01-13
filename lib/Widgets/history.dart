// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class New extends StatelessWidget {
  const New({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Color.fromARGB(0, 255, 255, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(
                  text: "Legends:",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [])),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          color: Colors.redAccent),
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Highest Voltage",
                            style: TextStyle(color: Colors.black)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          color: Colors.blueAccent),
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Lowest Voltage",
                            style: TextStyle(color: Colors.black)))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
