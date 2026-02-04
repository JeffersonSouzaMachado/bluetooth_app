import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothController extends GetxController {
  Future<bool> isBluetoothOn() async {

    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  Future scanDevices() async {
    final isOn = await isBluetoothOn();

    if (!isOn) {
      print('Bluetooth desligado');
      await FlutterBluePlus.turnOn();
      return;
    }

    print('Bluetooth ligado');

    final scanPermission = await Permission.bluetoothScan.request();
    final connectPermission = await Permission.bluetoothConnect.request();

    if (!scanPermission.isGranted || !connectPermission.isGranted) {
      print('Permissões negadas');
      return;
    }

    final loc = await Permission.locationWhenInUse.request();
    if (!loc.isGranted) {
      print('Location negada');
      return;
    }


    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

  }


  Stream<List<ScanResult>> get scanResult => FlutterBluePlus.scanResults;
}
