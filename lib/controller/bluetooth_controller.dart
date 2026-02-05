import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothController extends GetxController {

  ///Stream é carregado com o resultado que o pacote vai encontrando.
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  /// Verifica se está escaneando no momento
  Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  Future<void> scanDevices() async {
    // 1. Verificar Permissões primeiro
    if (!await _requestPermissions()) {
      print('Permissões negadas pelo usuário');
      return;
    }

    // 2. Verificar estado do adaptador
    // Nota: adapterState.first pega o estado atual imediatamente
    var state = await FlutterBluePlus.adapterState.first;

    if (state != BluetoothAdapterState.on) {
      print('Bluetooth desligado');
      if (GetPlatform.isAndroid) {
        await FlutterBluePlus.turnOn();
      } else {
        Get.snackbar("Aviso", "Por favor, ligue o Bluetooth nas configurações");
        return;
      }
    }

    // 3. Iniciar Scan (configurado para limpar resultados anteriores)
    // Usamos um timeout e garantimos que não haja scan duplo
    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: true, // Necessário para alguns dispositivos
      );
    } catch (e) {
      print("Erro ao iniciar scan: $e");
    }
  }

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  // Boa prática: parar o scan quando o controlador for destruído
  @override
  void onClose() {
    FlutterBluePlus.stopScan();
    super.onClose();
  }
}