import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Big_Sharepreferance {

  static final Big_Sharepreferance _instance = Big_Sharepreferance._internal();

  factory Big_Sharepreferance() {
    return _instance;
  }

  Big_Sharepreferance._internal();

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // static Future<String> getUser() async {
  //   final SharedPreferences prefs = await _prefs;
  //   return prefs.getString('username') ?? '';
  // }
  //
  // static Future<void> setUser(String name) async {
  //   final SharedPreferences prefs = await _prefs;
  //   await prefs.setString('username', name);
  // }
  //
  // static Future<String> getTips() async {
  //   final SharedPreferences prefs = await _prefs;
  //   return prefs.getString('tips') ?? '';
  // }
  //
  // static Future<void> setTips(String name) async {
  //   final SharedPreferences prefs = await _prefs;
  //   await prefs.setString('tips', name);
  // }
  //
  // static Future<String> getGfName() async {
  //   final SharedPreferences prefs = await _prefs;
  //   return prefs.getString('gfname') ?? '';
  // }
  //
  // static Future<void> setGfName(String name) async {
  //   final SharedPreferences prefs = await _prefs;
  //   await prefs.setString('gfname', name);
  // }
  //
  // static Future<String> getYourInterests() async {
  //   final SharedPreferences prefs = await _prefs;
  //   return prefs.getString('yourInterests') ?? '';
  // }
  //
  // static Future<void> setYourInterests(String name) async {
  //   final SharedPreferences prefs = await _prefs;
  //   await prefs.setString('yourInterests', name);
  // }

  static Future<int> getIntValue() async {
    final SharedPreferences prefs = await _prefs;
    final int storedValue = prefs.getInt('intValue') ?? 0;
    final int timestamp = prefs.getInt('intValueTimestamp') ?? 0;

    if (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp)).inHours > 24) {
      await prefs.remove('intValue');
      await prefs.remove('intValueTimestamp');
      return 0;
    }

    return storedValue;
  }

  static Future<void> setIntValue(int value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt('intValue', value);
    await prefs.setInt('intValueTimestamp', DateTime.now().millisecondsSinceEpoch);
  }

  static Future<int> getCreditValue(String coinvalueName) async {
    final SharedPreferences prefs = await _prefs;
    final int storedValue = prefs.getInt(coinvalueName) ?? 0;
    return storedValue;
  }

  static Future<void> setCreditValue(int coinvalue,String coinvalueName) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(coinvalueName, coinvalue);
  }

  // static Future<String> gettaskID() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final String storedValue = prefs.getString('taskID') ?? '';
  //   return storedValue;
  // }
  //
  // static Future<void> setaskID(String taskID) async {
  //   final SharedPreferences prefs = await _prefs;
  //   await prefs.setString('taskID', taskID);
  // }
  //
  // static Future<void> removeTaskID() async {
  //   final SharedPreferences prefs = await _prefs;
  //   await prefs.remove('taskID');
  // }
  //
  //
  //
  // static Future<String> getToken() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final String storedValue = prefs.getString('token') ?? '11';
  //   return storedValue;
  // }
  //
  // static Future<void> setToken(String token) async {
  //   final SharedPreferences prefs = await _prefs;
  //   await prefs.setString('token', token);
  // }



  // static const String videoStatusKey = 'videoStatus';
  //
  // static Future<void> setVideoStatus(String videoPath, String status) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final Map<String, String> videoStatusMap = await getVideoStatusMap();
  //
  //   videoStatusMap[videoPath] = status;
  //
  //   final String jsonMap = jsonEncode(videoStatusMap);
  //   prefs.setString(videoStatusKey, jsonMap);
  // }
  //
  // static Future<Map<String, String>> getVideoStatusMap() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? jsonMap = prefs.getString(videoStatusKey);
  //
  //   if (jsonMap != null) {
  //     final Map<String, String> videoStatusMap =
  //     Map<String, String>.from(jsonDecode(jsonMap));
  //     return videoStatusMap;
  //   } else {
  //     return {};
  //   }
  // }
}
