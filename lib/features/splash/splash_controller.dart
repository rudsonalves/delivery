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

import '../../common/models/user.dart';
import '../../locator.dart';
import '../../stores/user/user_store.dart';

class SplashController {
  final store = locator<UserStore>();

  UserModel? get currentUser => store.currentUser;
  bool get isLoggedIn => store.isLoggedIn;
  UserState get state => store.state;
  bool get userStatus => store.userStatus;

  Future<void> init() async {
    await store.initializeUser();
  }
}
