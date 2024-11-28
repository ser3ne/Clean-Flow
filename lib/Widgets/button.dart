// ignore_for_file: prefer_const_constructors

import 'package:capstone/Widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

// class MyButton extends StatelessWidget {
//   const MyButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () => showPopover(
// arrowDxOffset: -120,
//             direction: PopoverDirection.right,
//             context: context,
//             bodyBuilder: (context) => Menu(),
//             width: 250,
//             height: 300),
//         child: const Icon(
//           Icons.info_outline,
//         ));
//   }
// }

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => showPopover(
            arrowDxOffset: -146.4,
            context: context,
            bodyBuilder: (context) => Menu(),
            direction: PopoverDirection.bottom,
            arrowHeight: 0,
            arrowWidth: 10,
            width: 350,
            height: 360,
            backgroundColor: Color.fromARGB(142, 255, 255, 255)),
        child: const Icon(
          Icons.info_outline,
        ));
  }
}
