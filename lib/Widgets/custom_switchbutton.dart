// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CustomSwitchbuttonSmall extends StatefulWidget {
  const CustomSwitchbuttonSmall({super.key});

  @override
  State<CustomSwitchbuttonSmall> createState() =>
      _CustomSwitchbuttonSmallState();
}

class _CustomSwitchbuttonSmallState extends State<CustomSwitchbuttonSmall> {
  bool isConnected = false;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PairArguments;
    return GestureDetector(
      onTap: () async {
        setState(() {
          //starts as active, then press to de-activate
          //starts as false, then become true
          isConnected = !isConnected;
          // _savedDevices(context);
        });
        print(isConnected ? "Device is NOT Saved" : "Device is Saved");
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
                color: Colors.black,
                height: MediaQuery.of(context).size.height * .08,
                width: MediaQuery.of(context).size.width * .5,
                duration: Duration(milliseconds: 350),
                child: Container(
                  decoration: BoxDecoration(
                      color: isConnected ? Colors.blueGrey : Colors.blue,
                      borderRadius: BorderRadius.circular(25)),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      ChevLeft(
                          color: Color.fromARGB(255, 255, 255, 255),
                          left: isConnected ? 1 : 10,
                          size: 20),
                      ChevLeft(
                          color: Color.fromARGB(210, 216, 237, 255),
                          left: isConnected ? 1 : 20,
                          size: 20),
                      ChevLeft(
                          color: Color.fromARGB(180, 187, 222, 251),
                          left: isConnected ? 1 : 30,
                          size: 20),
                      ChevRight(
                          color: const Color.fromARGB(255, 255, 255, 255),
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
                            isConnected ? "Save Device?" : "Saved",
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
                    isConnected ? Icons.bluetooth_disabled : Icons.bluetooth,
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

class CustomSwitchButtonBig extends StatefulWidget {
  const CustomSwitchButtonBig(
      {super.key,
      required this.device,
      required this.dialogueText,
      required this.size});
  final BluetoothDevice device;
  final String dialogueText;
  final double size;

  @override
  State<CustomSwitchButtonBig> createState() => _CustomSwitchButtonBigState();
}

class _CustomSwitchButtonBigState extends State<CustomSwitchButtonBig> {
  void dialogueActionDisconnect() async {
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
  }

  Future<bool> confirmDisconnectionDialogue() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.device.platformName),
        contentPadding: EdgeInsets.all(10),
        content: Text(widget.dialogueText),
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
            onPressed: () {
              dialogueActionDisconnect();
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return isConnected;
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
        confirmDisconnectionDialogue();
      },
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                curve: Easing.emphasizedDecelerate,
                height: MediaQuery.of(context).size.height * .08,
                width: MediaQuery.of(context).size.width * .9,
                duration: Duration(milliseconds: 800),
                child: Container(
                  decoration: BoxDecoration(
                      color: isConnected ? Colors.blueGrey : Colors.blue,
                      borderRadius: BorderRadius.circular(25)),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      ChevLeft(
                          color: Color.fromARGB(255, 255, 255, 255),
                          left: 0,
                          size: widget.size),
                      ChevLeft(
                          color: Color.fromARGB(210, 216, 237, 255),
                          left: isConnected ? 0 : 20,
                          size: widget.size),
                      ChevLeft(
                          color: Color.fromARGB(180, 187, 222, 251),
                          left: isConnected ? 0 : 40,
                          size: widget.size),
                      ChevLeft(
                          color: Color.fromARGB(140, 167, 215, 255),
                          left: isConnected ? 0 : 60,
                          size: widget.size),
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
                curve: Curves.easeInOut,
                left: isConnected
                    ? (MediaQuery.of(context).size.width * .07)
                    : (MediaQuery.of(context).size.width * .78),
                duration: Duration(milliseconds: 400),
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
  const ChevLeft(
      {super.key, required this.color, required this.left, required this.size});
  final Color color;
  final double left;
  final double size;
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
        size: widget.size,
        color: widget.color,
      ),
    );
  }
}

class ChevRight extends StatefulWidget {
  const ChevRight(
      {super.key,
      required this.color,
      required this.size,
      required this.right});
  final Color color;
  final double right;
  final double size;
  @override
  State<ChevRight> createState() => _ChevRightState();
}

class _ChevRightState extends State<ChevRight> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      right: widget.right,
      duration: Duration(milliseconds: 300),
      child: Icon(
        Icons.chevron_right,
        size: widget.size,
        color: widget.color,
      ),
    );
  }
}
