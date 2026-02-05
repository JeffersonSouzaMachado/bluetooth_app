import 'package:bluetooth_app/controller/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final BluetoothController controller = Get.put(BluetoothController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Busca de Bluetooth',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: controller.scanResults,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      final deviceName = data.device.platformName.isNotEmpty
                          ? data.device.platformName
                          : "Dispositivo sem nome";

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: const Icon(
                            Icons.bluetooth,
                            color: Colors.blue,
                          ),
                          title: Text(deviceName),
                          subtitle: Text(data.device.remoteId.str),
                          trailing: Text('${data.rssi} dBm'),
                          onTap: () =>
                              print("Conectar ao: ${data.device.remoteId}"),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Nenhum dispositivo encontrado ou Bluetooth desligado',
                    ),
                  );
                }
              },
            ),
          ),

          StreamBuilder<bool>(
            stream: controller.isScanning,
            builder: (context, snapshot) {
              final isScanning = snapshot.data ?? false;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isScanning ? Colors.red : Colors.black,
                    ),
                    onPressed: isScanning ? null : () => controller.scanDevices(),
                    child: isScanning
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('BUSCAR DISPOSITIVOS', style: TextStyle(color: Colors.amber)),
                  ),
                ),
              );

              },
          ),
        ],
      ),
    );
  }
}
