import 'package:shared_preferences/shared_preferences.dart';

class SettingKeys {
  static const String disableSounds = "disableSounds";
  static const String disableWinNotifications = "disableWinNotifications";
}

class SharedPrefs {
  static late final SharedPreferences _instance;

  static init() async {
    _instance = await SharedPreferences.getInstance();
    // _instance.setBool(SettingKeys.disableSounds, false);
    // _instance.setBool(SettingKeys.disableWinNotifications, false);
  }  
  static SharedPreferences getInstance() {
    return _instance;
  }

  static enableSounds() {
    return _instance.setBool(SettingKeys.disableSounds, false);
  }
  static disableSounds() {
    return _instance.setBool(SettingKeys.disableSounds, true);
  }
  static bool isDisabledSounds() {
    return _instance.getBool(SettingKeys.disableSounds)!;
  }

  static enableWinNotifications() {
    return _instance.setBool(SettingKeys.disableWinNotifications, false);
  }
  static disableWinNotifications() {
    return _instance.setBool(SettingKeys.disableWinNotifications, true);
  }
  static bool isDisabledWinNotifications() {
    return _instance.getBool(SettingKeys.disableWinNotifications)!;
  }
}
