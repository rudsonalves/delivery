import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';

class ShopModel {
  String? id;
  String name;
  String? description;
  String userId;
  String? managerId;
  String? managerName;
  AddressModel? address;
  String? addressString;
  GeoPoint? geoAddress;

  ShopModel({
    this.id,
    required this.name,
    this.description,
    required this.userId,
    this.managerId,
    this.managerName,
    this.address,
    this.addressString,
    this.geoAddress,
  });

  ShopModel copyWith({
    String? id,
    String? name,
    String? description,
    String? userId,
    String? managerId,
    String? managerName,
    AddressModel? address,
    String? addressString,
    GeoPoint? geoAddress,
  }) {
    return ShopModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      address: address ?? this.address,
      addressString: addressString ?? this.addressString,
      geoAddress: geoAddress ?? this.geoAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'managerId': managerId,
      'managerName': managerName,
      'addressString': addressString,
      'geoAddress': geoAddress,
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String?,
      userId: map['userId'] as String,
      managerId: map['managerId'] as String?,
      managerName: map['managerName'] as String?,
      addressString: map['addressString'] as String?,
      geoAddress: map['geoAddress'] as GeoPoint?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopModel.fromJson(String source) =>
      ShopModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ShopModel(id: $id,'
        ' name: $name,'
        ' description: $description,'
        ' userId: $userId,'
        ' managerId: $managerId,'
        ' managerName: $managerName,'
        ' address: $address,'
        ' addressString: $addressString,'
        ' geoAddress: $geoAddress)';
  }

  @override
  bool operator ==(covariant ShopModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.userId == userId &&
        other.managerId == managerId &&
        other.managerName == managerName &&
        other.address == address &&
        other.addressString == addressString &&
        other.geoAddress == geoAddress;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        userId.hashCode ^
        managerId.hashCode ^
        managerName.hashCode ^
        address.hashCode ^
        addressString.hashCode ^
        geoAddress.hashCode;
  }
}
