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

import 'dart:convert';

import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import 'functions/model_functions.dart';

class AddressModel {
  String? id;
  String type;
  String zipCode;
  String street;
  String number;
  String? complement;
  String neighborhood;
  String state;
  String city;
  GeoFirePoint? location;
  DateTime? createdAt;
  DateTime? updatedAt;

  AddressModel({
    this.id,
    this.type = 'Residencial',
    required this.zipCode,
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.state,
    required this.city,
    this.location,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'zipCode': zipCode,
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'state': state,
      'city': city,
      'location': location?.data,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  String addressRepresentationString() {
    return 'Endereço ($type): $street, '
        'N° ${number.isNotEmpty ? number : 'S/N'}, '
        '${complement != null && complement!.isNotEmpty ? '$complement, ' : ''}'
        'Bairro $neighborhood, '
        '$city - $state, '
        'CEP: $zipCode';
  }

  String get geoAddressString {
    final cpmt =
        complement != null && complement!.isNotEmpty ? ' $complement,' : '';
    return '$street,'
        ' $number,$cpmt'
        ' $neighborhood,'
        ' $city,'
        ' $state,'
        ' $zipCode';
  }

  bool get isValidAddress =>
      street.isNotEmpty &&
      number.isNotEmpty &&
      neighborhood.isEmpty &&
      city.isNotEmpty &&
      state.isEmpty &&
      zipCode.isEmpty;

  AddressModel copyWith({
    String? id,
    String? type,
    String? zipCode,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? state,
    String? city,
    GeoFirePoint? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      type: type ?? this.type,
      zipCode: zipCode ?? this.zipCode,
      street: street ?? this.street,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      state: state ?? this.state,
      city: city ?? this.city,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] as String?,
      type: map['type'] as String,
      zipCode: map['zipCode'] as String,
      street: map['street'] as String,
      number: map['number'] as String,
      complement: map['complement'] as String?,
      neighborhood: map['neighborhood'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
      location:
          map['location'] != null ? mapToGeoFirePoint(map['location']) : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.zipCode == zipCode &&
        other.street == street &&
        other.number == number &&
        other.complement == complement &&
        other.neighborhood == neighborhood &&
        other.state == state &&
        other.city == city &&
        other.location == location &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        zipCode.hashCode ^
        street.hashCode ^
        number.hashCode ^
        complement.hashCode ^
        neighborhood.hashCode ^
        state.hashCode ^
        city.hashCode ^
        location.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'AddressModel(id: $id,'
        ' type: $type,'
        ' zipCode: $zipCode,'
        ' street: $street,'
        ' number: $number,'
        ' complement: $complement,'
        ' neighborhood: $neighborhood,'
        ' state: $state,'
        ' city: $city,'
        ' location: $location,'
        ' createdAt: $createdAt,'
        ' updatedAt: $updatedAt)';
  }
}
