import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../common/models/shop.dart';
import '../common/models/user.dart';

class LocalStorageService {
  static const _keyIsDark = 'isDark';
  static const _keyAdminChecked = 'checkedAdmin';
  static const _keyCachedUser = 'cachedUser';
  static const _keyManagerShops = 'managerShops';

  late SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isDark => _prefs.getBool(_keyIsDark) ?? true;
  bool get adminChecked => _prefs.getBool(_keyAdminChecked) ?? false;

  Future<void> setIsDark(bool value) async {
    await _prefs.setBool(_keyIsDark, value);
  }

  Future<void> setAdminChecked(bool value) async {
    await _prefs.setBool(_keyAdminChecked, value);
  }

  Future<void> setCachedUser(UserModel user) async {
    await _prefs.setString(_keyCachedUser, user.toJson());
  }

  UserModel? getCachedUser() {
    final cacheUser = _prefs.getString(_keyCachedUser);
    if (cacheUser != null) {
      return UserModel.fromJson(cacheUser);
    }
    return null;
  }

  Future<void> clearCachedUser() async {
    await _prefs.remove(_keyCachedUser);
    await _prefs.remove(_keyManagerShops);
  }

  Future<void> setManagerShops(List<ShopModel> shops) async {
    try {
      final List<String> listShops =
          shops.map((item) => item.toJson()).toList();
      await _prefs.setStringList(_keyManagerShops, listShops);
    } catch (err) {
      log('LocalStorageService.setManagerShops: $err');
    }
  }

  List<ShopModel> getManagerShops() {
    try {
      final result = _prefs.getStringList(_keyManagerShops);
      if (result == null) return [];
      return result.map((item) => ShopModel.fromJson(item)).toList();
    } catch (err) {
      log('LocalStorageService.getManagerShops: $err');
      return [];
    }
  }
}
