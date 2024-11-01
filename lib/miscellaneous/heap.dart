/*

if (!isConnected) {
                        var sub = BluetoothController().bluetoothConnectState();
                        await widget.device.disconnect();
                        await sub.cancel();
                        savedDevices.remove(widget.device);
                      }



/////////
StreamBuilder<List<ScanResult>>(
                          stream: FlutterBluePlus.scanResults,
                          initialData: [],
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              print(
                                  "Snapshot State: ${snapshot.connectionState}\n");
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              List<ScanResult> results = snapshot.data ?? [];
                              List<BluetoothDevice> filtered = [];
                              print('Snapshot Data: ${snapshot.data}\n');

                              if (results.isEmpty) {
                                print("Results: $results");
                                return Center(
                                  child: Text(
                                    "No Devices Found.\n",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                );
                              }
                              for (ScanResult device in results) {
                                if (device.device.platformName ==
                                    "Clean-Flow") {
                                  filtered.add(device.device);
                                } else {
                                  continue;
                                }
                              }

                              if (filtered.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No Devices Found.\n",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                );
                              }

                              //Devices
                              return ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  globalDevice = filtered[index];
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: SizedBox(
                                          width: 350,
                                          height: 300,
                                          //Device Profile Button
                                          child: FloatingActionButton(
                                            heroTag: null,
                                            onPressed: () async {
                                              Navigator.pushNamed(
                                                  context, '/deviceProfile',
                                                  arguments: DeviceArguments(
                                                      globalDevice!,
                                                      globalDevice!.platformName
                                                          .toString()));
                                              var subscription = globalDevice!
                                                  .connectionState
                                                  .listen(
                                                      (BluetoothConnectionState
                                                          state) async {
                                                if (state ==
                                                    BluetoothConnectionState
                                                        .disconnected) {
                                                  print(
                                                      "Global Device is Disconnected: ${globalDevice!.disconnectReason?.code} ${globalDevice!.disconnectReason?.description}");
                                                  Navigator.pop(context);
                                                }
                                              });
                                              globalDevice!
                                                  .cancelWhenDisconnected(
                                                      subscription,
                                                      delayed: true,
                                                      next: true);
                                              await globalDevice!.connect();
                                              subscription.cancel();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Icon(Icons
                                                        .bluetooth_searching)),
                                                Expanded(
                                                    flex: 5,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Device Name: ${globalDevice!.platformName.isEmpty ? "Unknown Device" : globalDevice!.platformName}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text(
                                                              "Device ID: ${globalDevice!.remoteId}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                          Text(
                                                              "Extra Info: ${globalDevice!.advName.isEmpty ? "--:--" : globalDevice!.advName}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis)
                                                        ],
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          )),
                                    ),
                                  );
                                },
                              );
                              //Devices end
                            } else {
                              return Center(
                                  child: Text("Error Scanning Devices."));
                            }
                          },
                        ),

//////////




Expanded(
                                                    flex: 5,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Device Name: ${globalDevice!.platformName.isEmpty ? "Unknown Device" : globalDevice!.platformName}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text(
                                                              "Device ID: ${globalDevice!.remoteId}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                          Text(
                                                              "Extra Info: ${globalDevice!.advName.isEmpty ? "--:--" : globalDevice!.advName}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis)
                                                        ],
                                                      ),
                                                    ))
















#define SERVICE_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"


List<BluetoothService> services = await device.discoverServices();

for (BluetoothService service in services) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
            if (characteristic.uuid.toString() ==
                "beb5483e-36e1-4688-b7f5-ea07361b26a8") {
              var value = characteristic.read();
              print("ESP32 Message: $value");
            }
          }
        }

if (characteristic.uuid.toString() == '4fafc201-1fb5-459e-8fcc-c5c9c331914b') {
          var value = await characteristic.read();
          setState(() {
            deviceMessage = String.fromCharCodes(value);
          });
        }













FlutterBluePlus.scanResults.listen((results) {
        if (results.isNotEmpty) {
          for (ScanResult result in results) {
            // Check if the device has the target Service UUID
            for (var serviceData in result.advertisementData.serviceUuids) {
              if (serviceData.toString().toLowerCase() ==
                  targetServiceUUID.toString().toLowerCase()) {
                print(
                    '\nFound device with target service UUID: ${result.device.platformName} (${result.device.remoteId})\n');
              }
            }
          }
        }
      }, onError: (e) => print(e));







Text(
                                                      "Device Name: ${device.platformName.isEmpty ? "Unknown Device" : device.platformName}", 
                                                    ),
                                                    Text(
                                                        "Device ID: ${device.remoteId}"),
                                                    Text(
                                                        "Extra Info: ${device.advName}")








StreamBuilder<List<ScanResult>>(
                  stream: FlutterBluePlus.scanResults,
                  initialData: [],
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print("Connection State: ${snapshot.connectionState}");
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData && snapshot.data != null) {
                      List<ScanResult> results = snapshot.data ?? [];
                      print('Snapshot Data: ${snapshot.data}');

                      // Update the foundDevices list
                      BluetoothController controller = BluetoothController();
                      controller.foundDevices.clear(); // Clear the list to avoid duplicates
                      for (var result in results) {
                        if (result.advertisementData.serviceUuids
                            .map((uuid) => uuid.toString().toLowerCase())
                            .contains(controller.targetServiceUUID.toLowerCase())) {
                          if (!controller.foundDevices.contains(result.device)) {
                            controller.foundDevices.add(result.device);
                          }
                        }
                      }

                      if (controller.foundDevices.isEmpty) {
                        return Center(
                          child: Text(
                            "No Devices Found.",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: controller.foundDevices.length,
                        itemBuilder: (context, index) {
                          final device = controller.foundDevices[index];





StreamBuilder<List<ScanResult>>(
                          stream: FlutterBluePlus.scanResults,
                          initialData: [],
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              print(
                                  "Connection State: ${snapshot.connectionState}");
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              List<ScanResult> results = snapshot.data ?? [];
                              print('Snapshot Data: ${snapshot.data}');

                              if (results.isEmpty) {
                                print("Results: $results");
                                return Center(
                                  child: Text(
                                    "No Devices Found.",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                );
                              }
                              //Devices
                              return ListView.builder(
                                itemCount: results.length,
                                itemBuilder: (context, index) {
                                  final device = results[index].device;






 */