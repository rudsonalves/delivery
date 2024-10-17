// Copyright (C) 2024 Rudson Alves
// 
// This file is part of delivery.
// 
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

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
