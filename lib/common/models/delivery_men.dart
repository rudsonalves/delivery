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

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '/common/models/functions/model_finctions.dart';

class DeliverymenModel {
  final String id;
  GeoFirePoint location;
  DateTime updatedAt;
  DateTime createdAt;

  DeliverymenModel({
    DateTime? updatedAt,
    DateTime? createdAt,
    required this.id,
    required this.location,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  DeliverymenModel copyWith({
    String? id,
    GeoFirePoint? location,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return DeliverymenModel(
      id: id ?? this.id,
      location: location ?? this.location,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'location': location.data,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory DeliverymenModel.fromMap(Map<String, dynamic> map) {
    return DeliverymenModel(
      id: map['id'] as String,
      location: mapToGeoFirePoint(map['location']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliverymenModel.fromJson(String source) =>
      DeliverymenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryMenModel(id: $id,'
        ' location: $location,'
        ' updatedAt: $updatedAt,'
        ' createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant DeliverymenModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.location == location &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        location.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode;
  }
}
