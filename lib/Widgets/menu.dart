// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Color.fromARGB(0, 255, 255, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(
                  text: "Thresholds of Safety:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black))),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
                text: "Voltages above ",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(style: TextStyle(color: Colors.red), text: "240V"),
                  TextSpan(
                      text:
                          " can potentially cause damage to equipment and pose risks to health.",
                      style: TextStyle(color: Colors.black))
                ]),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
                text: "Voltages below ",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(style: TextStyle(color: Colors.red), text: "180V"),
                  TextSpan(
                      text: " can potentially cause damage to equipment.",
                      style: TextStyle(color: Colors.black))
                ]),
          ),
          SizedBox(height: 10),
          const Divider(
            height: 10,
            thickness: 1,
            indent: 5,
            endIndent: 5,
            color: Colors.black45,
          ),
          RichText(
              text: TextSpan(
                  text: "Standard Operating Value:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black))),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
                text: "Nominal voltage is around ",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      style: TextStyle(color: Colors.green[400]), text: "230V"),
                  TextSpan(
                      text:
                          ", the values can vary slightly from the nominal voltage.",
                      style: TextStyle(color: Colors.black))
                ]),
          ),
          SizedBox(height: 10),
          const Divider(
            height: 10,
            thickness: 1,
            indent: 5,
            endIndent: 5,
            color: Colors.black45,
          ),
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
                            text: "Noise Signal",
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
                          color: Colors.greenAccent),
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Voltage",
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
                          border: Border.all(width: 2), color: Colors.yellow),
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Reduction",
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
