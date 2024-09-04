import 'dart:convert';

/// role descriptions
/// - admin: administrador do sistema.
/// - delivery: the one who makes the deliveries.
/// - client: the one who uses the service to deliver their products.
/// - consumer: the one who consumes the delivery service and the customer's
///   products.
enum UserRole { admin, delivery, client, consumer }

enum UserStatus { offline, online }

class UserModel {
  String? id;
  String name;
  String email;
  String? phone;
  String? password;
  UserRole role;
  UserStatus userStatus;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.password,
    this.role = UserRole.delivery,
    this.userStatus = UserStatus.offline,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      // 'password': password,
      'role': role.index,
      'userStatus': userStatus.index,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      // password: map['password'] != null ? map['password'] as String : null,
      role: UserRole.values[map['role'] as int],
      userStatus: UserStatus.values[map['userStatus'] as int],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
