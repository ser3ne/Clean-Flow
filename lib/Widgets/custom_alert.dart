import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({super.key, required this.device});
  final String device;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(device),
                  content: Text("$device had detected High Levels of Voltage"),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Dismiss"),
                    )
                  ],
                ));
      },
    );
  }
}
