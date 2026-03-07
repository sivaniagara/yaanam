import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getDeviceToken() async {
    try {
      // Note: Ensure Firebase is initialized in main.dart before calling this
      return await _firebaseMessaging.getToken();
    } catch (e) {
      return 'placeholder_token_for_dev';
    }
  }

  String getDeviceType() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else {
      return 'other';
    }
  }

  Future<String> getDeviceMacAddress() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id; // Unique ID for Android
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown_ios_id';
      }
      return 'unknown_id';
    } catch (e) {
      return 'error_id';
    }
  }
}
