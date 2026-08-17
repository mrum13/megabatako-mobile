import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class URLs {
  static String url =
      "http://127.0.0.1:8000"; // default sementara sebelum init selesai
  static String storageUrl = "-";

  static Future<void> init() async {
    url = await getBaseUrl();
    storageUrl = "${await getBaseUrl()}/storage/";
  }
}

Future<bool> isPhysicalDevice() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.isPhysicalDevice; // true = HP asli, false = emulator
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.isPhysicalDevice; // true = iPhone asli, false = simulator
  }

  return true; // fallback untuk platform lain (web, desktop, dll)
}

Future<String> getBaseUrl() async {
  final isReal = await isPhysicalDevice();

  String wifiConnection = "http://192.168.100.91:8000";
  String mobileHotspot = "http://192.168.52.220:8000";
  String emulatorConnection = "http://10.0.2.2:8000";
  String simulatorConnection = "http://127.0.0.1:8000";

  if (Platform.isAndroid) {
    return isReal ? mobileHotspot  : emulatorConnection;
  } else if (Platform.isIOS) {
    return isReal ? wifiConnection : simulatorConnection;
  }

  return "http://127.0.0.1:8000";
}


