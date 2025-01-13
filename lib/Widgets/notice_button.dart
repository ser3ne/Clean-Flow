// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NoticeButton extends StatelessWidget {
  const NoticeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
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
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 25),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Row(
                          children: [
                            Icon(Icons.bluetooth_disabled_rounded),
                            Text(
                              "Note:\n\t\t\tThe quick disconnect icon does\n\t\t\tnot save data.",
                            )
                          ],
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
        },
        child: const Icon(
          Icons.info_outline,
        ));
  }
}
