import 'package:capstone/Widgets/custom.dart';
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
              Navigator.pushNamedAndRemoveUntil(
                  context, root, (Route<dynamic> route) => false);
            },
            icon: const Icon(Icons.chevron_left_rounded)),
        title: Text(args.device.platformName),
      ),
      body: Center(
        child: CustomSwitchButton(
          device: args.device,
        ),
      ),
    );
  }
}
