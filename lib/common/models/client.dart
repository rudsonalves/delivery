import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import 'address.dart';
import 'functions/model_finctions.dart';

class ClientModel {
  String? id;
  String name;
  String? email;
  String phone;
  AddressModel? address;
  String? addressString;
  GeoFirePoint location;
  DateTime? createdAt;
  DateTime? updatedAt;

  ClientModel({
    this.id,
    required this.name,
    this.email,
    required this.phone,
    this.address,
    this.addressString,
    required this.location,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  ClientModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    AddressModel? address,
    String? addressString,
    GeoFirePoint? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address?.copyWith() ?? this.address?.copyWith(),
      addressString: addressString ?? this.addressString,
      location: location ?? this.location,
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
      'location': location.data,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      email: map['email'] as String?,
      phone: map['phone'] as String,
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

  @override
  String toString() {
    return 'ClientModel(id: $id, name: $name,'
        ' email: $email,'
        ' phone: $phone,'
        ' address: $address,'
        ' addressString: $addressString,'
        ' location: $location,'
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
        other.location == location &&
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
        location.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
