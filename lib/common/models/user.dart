// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
    this.emailVerified = false,
    this.photoURL,
    this.creationAt,
    this.lastSignIn,
  });

  static (String, IconData) ptUserRole(UserRole userRole) {
    String title;
    IconData icon;
    switch (userRole) {
      case UserRole.admin:
        title = 'Administrador';
        icon = Symbols.admin_panel_settings_rounded;
        break;
      case UserRole.delivery:
        title = 'Entregador';
        icon = Icons.delivery_dining_rounded;
        break;
      case UserRole.business:
        title = 'Comerciante';
        icon = Symbols.business;
        break;
      case UserRole.manager:
        title = 'Gerente';
        icon = Symbols.manage_accounts_rounded;
      default:
        title = 'Clique para entrar';
        icon = Symbols.people_rounded;
    }

    return (title, icon);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role.index,
      'userStatus': userStatus.index,
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
      emailVerified: emailVerified ?? this.emailVerified,
      photoURL: photoURL ?? this.photoURL,
      creationAt: creationAt ?? this.creationAt,
      lastSignIn: lastSignIn ?? this.lastSignIn,
    );
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
        ' emailVerified: $emailVerified\n,'
        ' photoURL: $photoURL\n,'
        ' creationAt: $creationAt\n,'
        ' lastSignIn: $lastSignIn)';
  }
}
