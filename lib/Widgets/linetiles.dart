// // ignore_for_file: prefer_const_constructors

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class LineTitles {
//   static const monthNames = [
//     "JANUARY",
//     "FEBRUARY",
//     "MARCH",
//     "APRIL",
//     "MAY",
//     "JUNE",
//     "JULY",
//     "AUGUST",
//     "SEPTEMBER",
//     "OCTOBER",
//     "NOVEMBER",
//     "DECEMBER"
//   ];

//   static getTitleData(int day, int month) => FlTitlesData(
//       topTitles: AxisTitles(
//           axisNameWidget: Text(
//             monthNames[month],
//           ),
//           sideTitles: SideTitles(
//             showTitles: false,
//           )),
//       rightTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: false,
//         ),
//       ),
//       bottomTitles: AxisTitles(
//           axisNameWidget: Text("WEEKS"),
//           sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 if (day < 8) {
//                   return Text("1");
//                 } else if (day < 15) {
//                   return Text("2");
//                 } else if (day < 22) {
//                   return Text("3");
//                 } else if (day < 29) {
//                   return Text("4");
//                 } else {
//                   return Text("5");
//                 }
//               })));
// }
