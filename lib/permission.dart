import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> check() async {
    if (Platform.isAndroid) {
      await Permission.contacts.request().isGranted;

      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.accessMediaLocation,
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
      ].request();

      for (var key in statuses.keys) {
        if (statuses[key]!.isDenied == true) {
          return false;
        }
      }
    }
    return true;
  }
}
