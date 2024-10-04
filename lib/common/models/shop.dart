import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';

class ShopModel {
  String? id;
  String name;
  String? description;
  String ownerId;
  String phone;
  String? managerId;
  String? managerName;
  AddressModel? address;
  String? addressString;
  GeoPoint geopoint;
  String geohash;
  DateTime? createdAt;
  DateTime? updatedAt;

  ShopModel({
    this.id,
    required this.name,
    this.description,
    required this.ownerId,
    required this.phone,
    this.managerId,
    this.managerName,
    this.address,
    this.addressString,
    required this.geopoint,
    required this.geohash,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  ShopModel copyWith({
    String? id,
    String? name,
    String? description,
    String? ownerId,
    String? phone,
    String? managerId,
    String? managerName,
    AddressModel? address,
    String? addressString,
    GeoPoint? geopoint,
    String? geohash,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShopModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      phone: phone ?? this.phone,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      address: address ?? this.address,
      addressString: addressString ?? this.addressString,
      geopoint: geopoint ?? this.geopoint,
      geohash: geohash ?? this.geohash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'phone': phone,
      'managerId': managerId,
      'managerName': managerName,
      'addressString': addressString,
      'geopoint': geopoint,
      'geohash': geohash,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String?,
      ownerId: map['ownerId'] as String,
      phone: map['phone'] as String,
      managerId: map['managerId'] as String?,
      managerName: map['managerName'] as String?,
      addressString: map['addressString'] as String?,
      geopoint: map['geopoint'] as GeoPoint,
      geohash: map['geohash'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  String toJson() {
    final map = toMap();
    map['id'] = id;
    map['geopoint'] = {
      'latitude': geopoint.latitude,
      'longitude': geopoint.longitude,
    };
    return json.encode(map);
  }

  factory ShopModel.fromJson(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    final geopoint = GeoPoint(
      map['geopoint']['latitude'] as double,
      map['geopoint']['longitude'] as double,
    );
    map['geopoint'] = geopoint;
    return ShopModel.fromMap(map);
  }

  @override
  String toString() {
    return 'ShopModel(id: $id,'
        ' name: $name,'
        ' description: $description,'
        ' ownerId: $ownerId,'
        ' phone: $phone,'
        ' managerId: $managerId,'
        ' managerName: $managerName,'
        ' address: $address,'
        ' addressString: $addressString,'
        ' geopoint: $geopoint,'
        ' geohash: $geohash,'
        ' createdAt: $createdAt,'
        ' updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ShopModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.ownerId == ownerId &&
        other.phone == phone &&
        other.managerId == managerId &&
        other.managerName == managerName &&
        other.address == address &&
        other.addressString == addressString &&
        other.geopoint == geopoint &&
        other.geohash == geohash &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        ownerId.hashCode ^
        phone.hashCode ^
        managerId.hashCode ^
        managerName.hashCode ^
        address.hashCode ^
        addressString.hashCode ^
        geopoint.hashCode ^
        geohash.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
