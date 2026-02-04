import 'package:bluetooth_app/controller/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bluetooth',
          style: TextStyle(color: Colors.amber, fontWeight: .bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        toolbarHeight: 100,
      ),
      body: GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (BluetoothController controller) {
          return Column(
            children: [
              StreamBuilder<List<ScanResult>>(
                stream: controller.scanResult,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data![index];
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(data.device.name),
                              subtitle: Text(data.device.id.id),
                              trailing: Text(data.rssi.toString()),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: Text('No devices found'));
                  }
                },
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.scanDevices();
                  },

                  child: Text('Buscar Devices'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
