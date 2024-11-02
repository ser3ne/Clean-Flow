// ignore_for_file: prefer_const_constructors

import 'package:capstone/Widgets/custom_switchbutton.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceOverview extends StatefulWidget {
  final BluetoothDevice device;
  final String platformName;
  final double size;
  const DeviceOverview(
      {super.key,
      required this.device,
      required this.platformName,
      required this.size});

  @override
  State<DeviceOverview> createState() => _DeviceOverviewState();
}

class _DeviceOverviewState extends State<DeviceOverview> {
  bool isConnected = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.60,
      height: MediaQuery.of(context).size.height * 0.40,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, deviceprofile,
              arguments: ConnectedArguments(widget.device));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: Text(
                  widget.device.advName.isEmpty
                      ? widget.device.advName
                      : widget.platformName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              //This is the action when the switch button is pressed
              Positioned(
                left: 10,
                top: 50,
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      //starts as active, then press to de-activate
                      //starts as false, then become true
                      isConnected = !isConnected;
                    });
                    // confirmDisconnectionDialogue();
                  },
                  child: Center(
                    child: Container(
                      // decoration: BoxDecoration(border: Border.all(width: 1)),
                      height: 50,
                      width: MediaQuery.of(context).size.width * .4,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedContainer(
                            height: MediaQuery.of(context).size.height * .08,
                            width: MediaQuery.of(context).size.width * .9,
                            duration: Duration(milliseconds: 350),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isConnected
                                      ? Colors.blueGrey
                                      : Colors.blue,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  ChevLeft(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      left: isConnected ? 1 : 10,
                                      size: widget.size),
                                  ChevLeft(
                                      color: Color.fromARGB(210, 216, 237, 255),
                                      left: isConnected ? 1 : 20,
                                      size: widget.size),
                                  ChevLeft(
                                      color: Color.fromARGB(180, 187, 222, 251),
                                      left: isConnected ? 1 : 30,
                                      size: widget.size),
                                  ChevRight(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      size: 20,
                                      right: isConnected ? 6 : 1),
                                  ChevRight(
                                      color: Color.fromARGB(255, 236, 239, 241),
                                      size: 20,
                                      right: isConnected ? 16 : 1),
                                  ChevRight(
                                      color: Color.fromARGB(255, 176, 190, 197),
                                      size: 20,
                                      right: isConnected ? 26 : 1),
                                  AnimatedPositioned(
                                      left: isConnected ? 50 : 65,
                                      duration: Duration(milliseconds: 350),
                                      child: Text(
                                        isConnected ? "save device?" : "Saved",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 10,
                                            color: Colors.white),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          AnimatedPositioned(
                            left: isConnected
                                ? (MediaQuery.of(context).size.width * .02)
                                : (MediaQuery.of(context).size.width * .30),
                            duration: Duration(milliseconds: 300),
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isConnected
                                      ? Color.fromARGB(255, 219, 219, 219)
                                      : Colors.white),
                              child: Icon(
                                isConnected
                                    ? Icons.bluetooth_disabled
                                    : Icons.bluetooth_connected,
                                color:
                                    isConnected ? Colors.blueGrey : Colors.blue,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: MediaQuery.of(context).size.width * .27,
                child: Text(
                  "<<< view more >>>",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
