import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _language = 'English';
  bool _orderNotifications = true;
  bool _promoNotifications = false;
  List<String> _savedAddresses = [];

  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  bool get orderNotifications => _orderNotifications;
  bool get promoNotifications => _promoNotifications;
  List<String> get savedAddresses => List.unmodifiable(_savedAddresses);
  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = (prefs.getBool('isDark') ?? false) ? ThemeMode.dark : ThemeMode.light;
    _language = prefs.getString('language') ?? 'English';
    _orderNotifications = prefs.getBool('notif_order') ?? true;
    _promoNotifications = prefs.getBool('notif_promo') ?? false;
    _savedAddresses = prefs.getStringList('addresses') ?? [];
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _themeMode == ThemeMode.dark);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }

  Future<void> setOrderNotifications(bool val) async {
    _orderNotifications = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_order', val);
    notifyListeners();
  }

  Future<void> setPromoNotifications(bool val) async {
    _promoNotifications = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_promo', val);
    notifyListeners();
  }

  Future<void> addAddress(String address) async {
    _savedAddresses = [..._savedAddresses, address];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('addresses', _savedAddresses);
    notifyListeners();
  }

  Future<void> removeAddress(int index) async {
    final list = [..._savedAddresses];
    list.removeAt(index);
    _savedAddresses = list;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('addresses', _savedAddresses);
    notifyListeners();
  }
}
