import 'package:capstone/Widgets/custom_alert.dart';
import 'package:flutter/material.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lorem Ipsum"),
      ),
      body: CustomAlert(device: "Lorem Ipsum"),
    );
  }
}
