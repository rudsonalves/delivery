import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';

class ClientModel {
  String? id;
  String name;
  String? email;
  String phone;
  AddressModel? address;
  String? addressString;
  GeoPoint? geoAddress;
  DateTime? createdAt;
  DateTime? updatedAt;

  ClientModel({
    this.id,
    required this.name,
    this.email,
    required this.phone,
    this.address,
    this.addressString,
    this.geoAddress,
    this.createdAt,
    this.updatedAt,
  });

  ClientModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    AddressModel? address,
    String? addressString,
    GeoPoint? geoAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      addressString: addressString ?? this.addressString,
      geoAddress: geoAddress ?? this.geoAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'addressString': addressString,
      'geoAddress': geoAddress,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      email: map['email'] as String?,
      phone: map['phone'] as String,
      addressString: map['addressString'] as String?,
      geoAddress: map['geoAddress'] as GeoPoint?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientModel.fromJson(String source) =>
      ClientModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClientModel(id: $id, name: $name,'
        ' email: $email,'
        ' phone: $phone,'
        ' address: $address,'
        ' addressString: $addressString,'
        ' geoAddress: $geoAddress,'
        ' createdAt: $createdAt,'
        ' updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ClientModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        other.addressString == addressString &&
        other.geoAddress == geoAddress &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        addressString.hashCode ^
        geoAddress.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
