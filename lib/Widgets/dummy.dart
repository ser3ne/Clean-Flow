import 'package:flutter/material.dart';

class Dummy extends StatelessWidget {
  const Dummy({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    String indexStr = index.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Data $indexStr", textAlign: TextAlign.center),
        Text("Data $indexStr", textAlign: TextAlign.center),
        Text("Data $indexStr", textAlign: TextAlign.center),
      ],
    );
  }
}
