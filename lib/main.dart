// ignore_for_file: prefer_const_constructors

import 'package:capstone/global/routes.dart';
import 'package:capstone/pages/device_profile.dart';
import 'package:capstone/pages/main_page.dart';
import 'package:capstone/pages/scanresult_page.dart';
import 'package:capstone/pages/shit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: root,
      routes: {
        root: (context) => Temp(),
        // root: (context) => MainPage(),
        deviceprofile: (context) => DeviceProfile(),
        scanresult: (context) => Scanresult_Page(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
