// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CustomSwitchButton extends StatefulWidget {
  const CustomSwitchButton({super.key, required this.device});
  final BluetoothDevice device;

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

/*
  NEED TO ADD CONFIRMATION WHEN DISCONNECTING!
  NEED TO ADD CONFIRMATION WHEN DISCONNECTING!
  NEED TO ADD CONFIRMATION WHEN DISCONNECTING!
  NEED TO ADD CONFIRMATION WHEN DISCONNECTING!
  NEED TO ADD CONFIRMATION WHEN DISCONNECTING!
  NEED TO ADD CONFIRMATION WHEN DISCONNECTING!
  NEED TO ADD CONFIRMATION WHEN DISCONNECTING!
  NEED TO ADD CONFIRMATION WHEN DISCONNECTING!
 */
class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  Future<bool> confirmDisconnection() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.device.platformName),
        contentPadding: EdgeInsets.all(10),
        content: Text("Are you Sure you want to Disconnect?"),
        actions: [
          MaterialButton(
            color: Colors.lightBlue,
            onPressed: () {
              setState(() {
                isConnected = false;
                Navigator.pop(context);
              });
            },
            child: Text("No"),
          ),
          MaterialButton(
            color: Colors.lightBlue,
            onPressed: () async {
              var sub = BluetoothController().bluetoothConnectState();
              await widget.device.disconnect();
              await sub.cancel();
              if (widget.device.isDisconnected) {
                connectedDevices.remove(widget.device);
                Navigator.pushNamedAndRemoveUntil(
                    context, root, (Route<dynamic> route) => false);
              } else {
                setState(() {
                  isConnected = false;
                });
              }
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return false;
  }

  bool isConnected = globalBoolean;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          //starts as active, then press to de-activate
          //starts as false, then become true
          isConnected = !isConnected;
        });
        confirmDisconnection();
      },
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                height: MediaQuery.of(context).size.height * .08,
                width: MediaQuery.of(context).size.width * .9,
                duration: Duration(milliseconds: 350),
                child: Container(
                  decoration: BoxDecoration(
                      color: isConnected ? Colors.blueGrey : Colors.blue,
                      borderRadius: BorderRadius.circular(25)),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      ChevLeft(
                          color: Color.fromARGB(255, 255, 255, 255), left: 0),
                      ChevLeft(
                          color: Color.fromARGB(210, 216, 237, 255),
                          left: isConnected ? 0 : 20),
                      ChevLeft(
                          color: Color.fromARGB(180, 187, 222, 251),
                          left: isConnected ? 0 : 40),
                      ChevLeft(
                          color: Color.fromARGB(140, 167, 215, 255),
                          left: isConnected ? 0 : 60),
                      AnimatedPositioned(
                          left: isConnected ? 120 : 105.5,
                          duration: Duration(milliseconds: 350),
                          child: Text(
                            isConnected ? "Are you sure?" : "Disconnect Device",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 17,
                                color: Colors.white),
                          ))
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                left: isConnected
                    ? (MediaQuery.of(context).size.width * .07)
                    : (MediaQuery.of(context).size.width * .78),
                duration: Duration(milliseconds: 300),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isConnected
                          ? Color.fromARGB(255, 219, 219, 219)
                          : Colors.white),
                  child: Icon(
                    isConnected
                        ? Icons.bluetooth_disabled
                        : Icons.bluetooth_connected,
                    color: isConnected ? Colors.blueGrey : Colors.blue,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChevLeft extends StatefulWidget {
  const ChevLeft({super.key, required this.color, required this.left});
  final Color color;
  final double left;
  @override
  State<ChevLeft> createState() => _ChevLeftState();
}

class _ChevLeftState extends State<ChevLeft> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: widget.left,
      duration: Duration(milliseconds: 300),
      child: Icon(
        Icons.chevron_left_rounded,
        size: 55,
        color: widget.color,
      ),
    );
  }
}
