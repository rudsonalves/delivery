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
  GeoPoint? geopoint;

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
    this.geopoint,
  });

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
      geopoint: map['geopoint'] as GeoPoint?,
    );
  }

  String toJson() {
    final map = toMap();
    map['id'] = id;
    map['geopoint'] = {
      'latitude': geopoint!.latitude,
      'longitude': geopoint!.longitude,
    };
    return json.encode(map);
  }

  factory ShopModel.fromJson(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    final geopoint = GeoPoint(
      map['geopoint']['latitude'] as double,
      map['geopoint']['longitude'] as double,
    );
    map.remove('geopoint');
    final shop = ShopModel.fromMap(map);
    return shop.copyWith(geopoint: geopoint);
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
        ' geopoint: $geopoint)';
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
        other.geopoint == geopoint;
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
        geopoint.hashCode;
  }
}
