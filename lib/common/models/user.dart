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

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// role descriptions
/// - admin: administrador do sistema.
/// - delivery: the one who makes the deliveries.
/// - business: the one who consumes the delivery service and the customer's
///   products.
enum UserRole { admin, business, delivery, manager }

enum UserStatus { offline, online }

class UserModel {
  String? id;
  String name;
  String email;
  String? phone;
  String? password;
  UserRole role;
  UserStatus userStatus;
  String? bossId;
  bool emailVerified;
  String? photoURL;
  DateTime? creationAt;
  DateTime? lastSignIn;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.password,
    this.role = UserRole.delivery,
    this.userStatus = UserStatus.offline,
    this.bossId,
    this.emailVerified = false,
    this.photoURL,
    this.creationAt,
    this.lastSignIn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role.index,
      'userStatus': userStatus.index,
      'bossId': bossId,
      'emailVerified': emailVerified,
      'photoURL': photoURL,
      'creationAt': creationAt?.millisecondsSinceEpoch,
      'lastSignIn': lastSignIn?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      role: UserRole.values[map['role'] as int],
      userStatus: UserStatus.values[map['userStatus'] as int],
      bossId: map['managerId'] as String?,
      emailVerified: map['emailVerified'] as bool,
      photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
      creationAt: map['creationAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['creationAt'] as int)
          : null,
      lastSignIn: map['lastSignIn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSignIn'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    UserRole? role,
    UserStatus? userStatus,
    String? bossId,
    bool? emailVerified,
    String? photoURL,
    DateTime? creationAt,
    DateTime? lastSignIn,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      role: role ?? this.role,
      userStatus: userStatus ?? this.userStatus,
      bossId: bossId ?? this.bossId,
      emailVerified: emailVerified ?? this.emailVerified,
      photoURL: photoURL ?? this.photoURL,
      creationAt: creationAt ?? this.creationAt,
      lastSignIn: lastSignIn ?? this.lastSignIn,
    );
  }

  String get accountId {
    switch (role) {
      case UserRole.admin:
        return 'admin';
      case UserRole.business:
        return id!;
      case UserRole.delivery:
        return 'none';
      case UserRole.manager:
        return bossId ?? 'none';
    }
  }

  @override
  String toString() {
    return 'UserModel(id: $id\n,'
        ' name: $name\n,'
        ' email: $email\n,'
        ' phone: $phone\n,'
        ' password: $password\n,'
        ' role: ${role.name}\n,'
        ' userStatus: ${userStatus.name}\n,'
        ' bossId: $bossId\n,'
        ' emailVerified: $emailVerified\n,'
        ' photoURL: $photoURL\n,'
        ' creationAt: $creationAt\n,'
        ' lastSignIn: $lastSignIn)';
  }
}
