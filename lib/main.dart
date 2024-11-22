// ignore_for_file: prefer_const_constructors

import 'package:capstone/global/routes.dart';
import 'package:capstone/pages/home_page.dart';
import 'package:capstone/pages/main_page.dart';
import 'package:capstone/pages/scanresult_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(
    Duration(seconds: 4),
    () {
      FlutterNativeSplash.remove();
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: root,
      routes: {
        root: (context) => MainPage(),
        scanresult: (context) => Scanresult_Page(),
        homepage: (context) => Home_Page()
      },
      title: 'Clean-Flow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
