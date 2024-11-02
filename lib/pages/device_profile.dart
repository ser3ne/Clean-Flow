import 'package:capstone/Widgets/custom_switchbutton.dart';
import 'package:capstone/global/args.dart';
import 'package:capstone/global/routes.dart';
import 'package:flutter/material.dart';

class DeviceProfile extends StatefulWidget {
  const DeviceProfile({super.key});
  @override
  State<DeviceProfile> createState() => _DeviceProfileState();
}

class _DeviceProfileState extends State<DeviceProfile> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ConnectedArguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, deviceprofile);
            },
            icon: const Icon(Icons.chevron_left_rounded)),
        title: Text(args.device.platformName),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(border: Border.all(width: 5)),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(border: Border.all(width: 5)),
                child: CustomSwitchButton(
                  device: args.device,
                  dialogueText: "Are you Sure you want to Disconnect?",
                  size: 55,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
