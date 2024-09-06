// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'address.dart';

class ClientModel {
  String? id;
  String name;
  String? email;
  String phone;
  AddressModel? address;
  DateTime createdAt;
  DateTime? updatedAt;

  ClientModel({
    this.id,
    required this.name,
    this.email,
    required this.phone,
    this.address,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  ClientModel copyWith({
    String? name,
    String? email,
    String? phone,
    AddressModel? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address?.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      name: map['name'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] as String,
      address: AddressModel.fromMap(map['address'] as Map<String, dynamic>),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientModel.fromJson(String source) =>
      ClientModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClientModel(name: $name,'
        ' email: $email,'
        ' phone: $phone,'
        ' address: $address,'
        ' createdAt: $createdAt,'
        ' updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ClientModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
