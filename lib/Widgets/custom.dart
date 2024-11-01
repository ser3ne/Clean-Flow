// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      required this.text,
      required this.size,
      required this.fontWeight});
  final String text;
  final double size;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size, fontWeight: fontWeight),
    );
  }
}

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
        if (isConnected) {
          var sub = BluetoothController().bluetoothConnectState();
          await widget.device.disconnect();
          await sub.cancel();
          await connectedDevices.remove(widget.device);
          Navigator.pushNamedAndRemoveUntil(
              context, root, (Route<dynamic> route) => false);
        }
      },
      child: Center(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .14,
              width: MediaQuery.of(context).size.width * .8,
              color: Colors.amberAccent,
            ),
            AnimatedPositioned(
              top: MediaQuery.of(context).size.width * .05,
              left: MediaQuery.of(context).size.width * .08,
              right: MediaQuery.of(context).size.width * .08,
              duration: Duration(milliseconds: 200),
              child: Container(
                height: 75,
                width: MediaQuery.of(context).size.width * .7,
                decoration: BoxDecoration(
                    color: isConnected ? Colors.blueGrey : Colors.blue[200],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 55,
                    ),
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 55,
                    ),
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 55,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              top: MediaQuery.of(context).size.width * .02,
              left: isConnected ? 10 : MediaQuery.of(context).size.width * .56,
              duration: Duration(milliseconds: 300),
              child: Container(
                height: 100,
                width: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isConnected ? Colors.blueGrey : Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
