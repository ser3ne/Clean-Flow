/*
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