// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:capstone/Controllers/bluetooth_controller.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/pages/device_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceOverview extends StatefulWidget {
  const DeviceOverview({
    super.key,
    required this.deviceMac,
    required this.platformName,
    required this.removeDevice,
  });

  final String platformName;
  final String deviceMac;
  final Future<void> Function(BuildContext, String, String) removeDevice;

  @override
  State<DeviceOverview> createState() => _DeviceOverviewState();
}

/*

Fix Navigation bug
need to stop the duplication

 */
class _DeviceOverviewState extends State<DeviceOverview> {
  bool isConnected = true;
  // bool isTapped = false;

  //When the Device is found we navigate to the profile
  Future<void> goToProfile(BuildContext context) async {
    for (var dev in copyResult) {
      // Check if the device MAC address matches
      if (dev.remoteId.toString() == widget.deviceMac) {
        bool x = await confirmConnectionDialog(context, true);
        if (x) {
          BluetoothDevice device = dev;
          var connectionStateStream =
              BluetoothController().bluetoothConnectState(device);

          // Check if the device is already connected
          if (device.isConnected) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeviceProfile(
                  args: PairArguments(
                      device, device.platformName, device.remoteId.toString()),
                ),
              ),
            );
            // Navigator.pushNamed(
            //   context,
            //   deviceprofile,
            //   arguments: PairArguments(
            //     device,
            //     device.platformName,
            //     device.remoteId.toString(),
            //   ),
            // );
            break;
          } else {
            try {
              // Disconnect global device if any, and cancel the previous subscription
              if (connectedDevices.isNotEmpty) {
                await connectedDevices[0].disconnect();
                // Clear previous connections and connect to the new device
                setState(() {
                  connectedDevices.clear();
                });
              }
              await connectionStateStream.cancel();
            } catch (e) {
              print("Device Overview: $e");
            }

            await device.connect();

            if (device.isConnected) {
              setState(() {
                globalDevice = device;
                connectedDevices.add(
                    device); // Ensure the device is added only if not connected already
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => DeviceProfile(
                    args: PairArguments(device, device.platformName,
                        device.remoteId.toString()),
                  ),
                ),
                (Route<dynamic> route) => false, // Removes all previous routes
              );
              // Navigator.pushNamedAndRemoveUntil(
              //     context, deviceprofile, (Route<dynamic> route) => false);
              break;
            }
          }
        }
        break;
      }
    }
  }

  Future<bool> confirmConnectionDialog(
      BuildContext context, bool confirm) async {
    bool x = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.platformName),
        content: confirm ? Text("Connect to Device?") : Text("Forget Device?"),
        actions: [
          // No Option
          MaterialButton(
            color: Colors.lightBlue,
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text("No"),
          ),
          SizedBox(width: 60),
          // Yes Option
          MaterialButton(
            color: Colors.lightBlue,
            onPressed: () async {
              // true for reconnection

              if (confirm) {
                //checks if bluetooth is on or off
                //we return true
                setState(() {
                  x = true;
                });
                Navigator.pop(context); // Close dialog before navigating
                // Only navigate after closing the dialog
              }
              // false for removing saved device
              else {
                widget.removeDevice(
                  context,
                  widget.deviceMac,
                  widget.platformName,
                );
                Navigator.pop(context); // Close dialog
              }
            },
            child: Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      width: MediaQuery.of(context).size.width * 0.50,
      height: MediaQuery.of(context).size.height * 0.12,
      child: FloatingActionButton(
        onPressed: () async {
          bool y = await BluetoothController().checkAdapterState();
          //if false
          if (!y) {
            //ask the user to turn on the bluetooth
            await FlutterBluePlus.turnOn();
            y = await BluetoothController().checkAdapterState();
            //if it's on we start connection process
            if (y) {
              //To connect... the only problem is that we have to scan first
              //then connect to the saved devices, which is very scuffed
              try {
                await goToProfile(context);
              } finally {}
            }
          } else {
            try {
              await goToProfile(context);
            } finally {}
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.platformName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    isConnected
                        ? Icons.bookmark_added_rounded
                        : Icons.bookmark_remove_outlined,
                    size: 30,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,

                    //put the remove function here
                    child: Switch(
                      inactiveTrackColor: Colors.white,
                      activeTrackColor: Colors.blueAccent,
                      inactiveThumbColor: Colors.black,
                      value: isConnected,
                      onChanged: (value) async {
                        setState(() {
                          isConnected = value;
                        });
                        await confirmConnectionDialog(context, false);
                      },
                    ),
                  ),
                  Expanded(flex: 5, child: SizedBox.shrink()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
