import 'dart:convert';

import 'package:delivery/common/models/functions/models_finctions.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

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
  GeoFirePoint location;
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
    required this.location,
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
    GeoFirePoint? location,
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
      location: location ?? this.location,
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
      'location': location.data,
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
      location: mapToGeoFirePoint(map['location']),
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
    map['location']['geopoint'] = {
      'latitude': location.latitude,
      'longitude': location.longitude,
    };
    return json.encode(map);
  }

  factory ShopModel.fromJson(String source) =>
      ShopModel.fromMap(json.decode(source) as Map<String, dynamic>);

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
        ' location: $location,'
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
        other.location == location &&
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
        location.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
