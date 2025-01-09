// ignore_for_file: unrelated_type_equality_checks, prefer_const_constructors

import 'dart:convert';

import 'package:capstone/global/args.dart';
import 'package:capstone/pages/historical_data_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoricalDevicesPage extends StatefulWidget {
  const HistoricalDevicesPage({super.key, required this.deviceName});

  final String deviceName;

  @override
  State<HistoricalDevicesPage> createState() => HhistoricalDStateevicesPage();
}

class HhistoricalDStateevicesPage extends State<HistoricalDevicesPage> {
  List<dynamic> historicalDevices = [];
  List<dynamic> historicalData = [];
  List<dynamic> conjoinedHistory = [];

  Future<dynamic> history() async {}

  Future<void> _loadHistoricalDevices() async {
    final prefs = await SharedPreferences.getInstance();
    String? devicesString = prefs.getString('historicalDevices');
    String? dataString = prefs.getString('historicalData');
    setState(() {
      historicalDevices =
          devicesString != null ? jsonDecode(devicesString) : [];
      historicalData = dataString != null ? jsonDecode(dataString) : [];
    });


    var matchID = historicalDevices.firstWhere((id) => id['id'] == 1, orElse: () => null,);
    historicalData['info'] = matchID;



    // var mac = historicalDevices.firstWhere((device) {
    //   var datamac = historicalData.firstWhere(
    //     (data) => data['mac'] == device['mac'],
    //     orElse: () => null,
    //   );
    //   return datamac != null;
    // });

    // //checking if mac is null, if it's not we add it to the list
    // mac == null ? [] : conjoinedHistory.add(mac);
  }

  @override
  void initState() {
    super.initState();
    _loadHistoricalDevices();
  }

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
                    itemCount: historicalDevices.isEmpty
                        ? 1
                        : historicalDevices.length,
                    itemBuilder: (context, index) {
                      var device = historicalDevices.isEmpty ? 0 : historicalData[index];
                      //Check if it is empty
                      if (historicalDevices.isEmpty ||
                          historicalDevices.isEmpty == "" ||
                          historicalDevices.isEmpty == []) {
                        return Center(
                            child: Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Text(
                              "No Devices History",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ));
                      }
                      for (var item1 in historicalDevices) {
                        var matchID = historicalData.firstWhere(
                          (item2) => item2['id'] == item1['id'],
                          orElse: () => null,
                        );

                        matchID.remove('id');

                        if (item1['info'] == null) {
                          item1['info'] == [];
                        }

                        
                      }

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
                                    builder: (context) => HistoricalDataPage(index: index,device: device, nigga: shit(historicalDevices[], mac, year, month, day, hour, minute, perc, voltag, high, low),),
                                  ),
                                );
                              },
                              child: Center(child: Text(device['name']))));

                      //this is for taking the respective data from a device.
                      //we cannot use the mac address because we don't have a reference
                      //therefore we use an ID which fits perfectly with our ID system
                    },
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

// if (d&t == historical)
