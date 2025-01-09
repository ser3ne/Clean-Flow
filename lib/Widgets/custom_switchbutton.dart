// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:convert';

import 'dart:convert';

import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CustomSwitchButtonBig extends StatefulWidget {
  const CustomSwitchButtonBig(
      {super.key,
      required this.device,
      required this.dialogueText,
      required this.size,
      required this.percentReduction,
      required this.high,
      required this.low,
      required this.voltage});
  final BluetoothDevice device;
  final String dialogueText, percentReduction;
  final double size;
  final int high, low, voltage;

  @override
  State<CustomSwitchButtonBig> createState() => _CustomSwitchButtonBigState();
}

class _CustomSwitchButtonBigState extends State<CustomSwitchButtonBig> {
  List<dynamic> historicalData = [];
  Future<void> _historicalData(String macAdd, pfName, year, month, day, hour,
      minute, perc, voltage, high, low) async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString('historicalData');
    historicalData = jsonString != null ? jsonDecode(jsonString) : [];

    bool doesDeviceExists = historicalData.any(
      (uid) => uid['mac'] == macAdd,
    );

    //if it does not exist we will add it and give it an ID
    if (!doesDeviceExists) {
      //acquire the ID with the biggest value
      int autoIncrementID = historicalData.isNotEmpty
          ? historicalData.map((item) => item['id']).reduce(
                (current, next) => current > next ? current : next,
              )
          : 0;
      autoIncrementID = autoIncrementID + 1;

      setState(() {
        historicalData.add({
          'id': autoIncrementID.toString(),
          'mac': macAdd,
          'info': [
            {
              'year': year,
              'month': month,
              'day': day,
              'hour': hour,
              'minute': minute,
              'perc': perc,
              'voltage': voltage,
              'high': high,
              'low': low
            }
          ]
        });
      });
    }
    //if it already exists, we find the mac address,
    //get the "info" key, then add the new data
    else {
      var info = historicalData.firstWhere(
        (data) => data['mac'] == macAdd,
      );

      info['info'].add({
        'year': year,
        'month': month,
        'day': day,
        'hour': hour,
        'minute': minute,
        'perc': perc,
        'voltage': voltage,
        'high': high,
        'low': low
      });
    }

    await prefs.setString('historicalData', jsonEncode(historicalData));

    List<dynamic> sample = [];
    sample = jsonString != null ? jsonDecode(jsonString) : [];

    var item = sample.firstWhere((item) => item['id'] == 1);
    print("ITEM:");
    print(item);
  }

  void dialogueActionDisconnect(BluetoothDevice device) async {
    var sub = BluetoothController().bluetoothConnectState(device);
    await widget.device.disconnect();
    await sub.cancel();
    if (widget.device.isDisconnected) {
      //this will remove all the device in connected device
      //The Idea is that we will only store one device at a time
      //we then will remove that device if we disconnect.
      //but will leave a list of saved devices so we can access them later
      connectedDevices.clear();
      Navigator.pushNamedAndRemoveUntil(
          context, root, (Route<dynamic> route) => false);
    } else {
      setState(() {
        globalDevice = null;
        isConnected = false;
      });
    }
  }

  Future<bool> confirmDisconnectionDialogue(BluetoothDevice device) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: double.infinity,
          height: 60,
          // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Colors.red),
          child: Center(
            child: Icon(
              Icons.warning_amber_rounded,
              size: 50,
            ),
          ),
        ),
        content: SizedBox(
          height: 100,
          child: Column(
            children: [
              Center(
                child: Text(
                  "Disconnect?",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                ),
              ),
              Center(
                child: Text(
                  "Would you disconnect from the device?",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        actions: [
          //~~~~~~~~~~~~~~~~NO~~~~~~~~~~~~~~~~~~
          MaterialButton(
              color: Colors.red,
              onPressed: () {
                setState(() {
                  isConnected = false;
                });
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style: TextStyle(color: Colors.black),
              )),
          SizedBox(
            width: 60,
          ),
          //~~~~~~~~~~~~~~~~YES~~~~~~~~~~~~~~~~~~
          MaterialButton(
              color: Colors.redAccent,
              onPressed: () {
                DateTime current = DateTime.now();
                String year = current.year.toString();
                String month = current.month.toString();
                String day = current.day.toString();
                String hour = current.hour.toString();
                String minute = current.minute.toString();
                _historicalData(
                    device.remoteId.toString(),
                    device.platformName,
                    year,
                    month,
                    day,
                    hour,
                    minute,
                    widget.percentReduction,
                    widget.voltage.toString(),
                    widget.high.toString(),
                    widget.low.toString());
                dialogueActionDisconnect(device);
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ))
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
        //double check line 177
        isConnected = await confirmDisconnectionDialogue(widget.device);
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
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 7,
                            color: Color.fromARGB(20, 0, 0, 0),
                            spreadRadius: 3,
                            offset: Offset(0, 5)),
                      ],
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
                    ? (MediaQuery.of(context).size.width * .03)
                    : (MediaQuery.of(context).size.width * .66),
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
        Icons.chevron_right_rounded,
        size: widget.size,
        color: widget.color,
      ),
    );
  }
}
