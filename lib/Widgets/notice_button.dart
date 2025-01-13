// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NoticeButton extends StatelessWidget {
  const NoticeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: const Icon(
          Icons.info_outline,
        ));
  }
}
