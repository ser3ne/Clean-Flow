import 'package:capstone/global/args.dart';
import 'package:capstone/pages/historical_data_page.dart';
import 'package:flutter/material.dart';

class HistoricalDevicesPage extends StatefulWidget {
  const HistoricalDevicesPage({super.key});

  @override
  State<HistoricalDevicesPage> createState() => HhistoricalDStateevicesPage();
}

class HhistoricalDStateevicesPage extends State<HistoricalDevicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [colorX, colorY],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(55, 255, 255, 255),
                      Color.fromARGB(55, 255, 255, 255)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(40)),
              //ListView for Saved Devices
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                    itemCount: 25,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: FloatingActionButton(
                          heroTag: index,
                          shape: BeveledRectangleBorder(
                              side: BorderSide(width: 1)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoricalDataPage(),
                              ),
                            );
                          },
                          child: Center(child: Text("Deez Nuts")),
                        ),
                      );
                    },
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
