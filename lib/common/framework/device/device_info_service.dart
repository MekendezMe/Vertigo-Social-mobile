import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static Future<String> getUserAgent() async {
    String osName = '';
    String osVersion = '';
    String deviceModel = '';

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      osName = 'iOS';
      osVersion = iosInfo.systemVersion;
      deviceModel = iosInfo.utsname.machine;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      osName = 'Android';
      osVersion = androidInfo.version.release;
      deviceModel = androidInfo.model;
    }

    return '$deviceModel;$osName';
  }
}
