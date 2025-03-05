import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BIG_SharedPreferencesService {

  static final BIG_SharedPreferencesService _instance = BIG_SharedPreferencesService._internal();

  factory BIG_SharedPreferencesService() {
    return _instance;
  }

  BIG_SharedPreferencesService._internal();

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  static Future<String> getUser() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('username') ?? '';
  }

  static Future<void> setUser() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('username','username');
  }

  static Future<String> getTips() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('tips') ?? '';
  }

  static Future<void> setTips(String name) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('tips', name);
  }

  static Future<String> getGfName() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('gfname') ?? '';
  }

  static Future<void> setGfName(String name) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('gfname', name);
  }

  static Future<String> getYourInterests() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('yourInterests') ?? '';
  }

  static Future<void> setYourInterests(String name) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('yourInterests', name);
  }

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

  static const String videoStatusKey = 'videoStatus';

  static Future<void> setVideoStatus(String videoPath, String status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, String> videoStatusMap = await getVideoStatusMap();

    videoStatusMap[videoPath] = status;

    final String jsonMap = jsonEncode(videoStatusMap);
    prefs.setString(videoStatusKey, jsonMap);
  }

  static Future<Map<String, String>> getVideoStatusMap() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonMap = prefs.getString(videoStatusKey);

    if (jsonMap != null) {
      final Map<String, String> videoStatusMap =
      Map<String, String>.from(jsonDecode(jsonMap));
      return videoStatusMap;
    } else {
      return {};
    }
  }
}
