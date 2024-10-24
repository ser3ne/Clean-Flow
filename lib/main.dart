// ignore_for_file: prefer_const_constructors

import 'package:capstone/Widgets/device_overview.dart';
import 'package:capstone/pages/home_page.dart';
import 'package:capstone/pages/main_page.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage()
        // '/': (context) => Scanresult_Page(),
        // '/deviceProfile': (context) => DeviceProfiles()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
