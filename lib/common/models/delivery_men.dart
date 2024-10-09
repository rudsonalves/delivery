// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DeliverymenModel {
  final String id;
  GeoPoint geopoint;
  String geohash;
  DateTime updatedAt;
  DateTime createdAt;

  DeliverymenModel({
    DateTime? updatedAt,
    DateTime? createdAt,
    required this.id,
    required this.geopoint,
    required this.geohash,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  DeliverymenModel copyWith({
    String? id,
    GeoPoint? geopoint,
    String? geohash,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return DeliverymenModel(
      id: id ?? this.id,
      geopoint: geopoint ?? this.geopoint,
      geohash: geohash ?? this.geohash,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'geopoint': geopoint,
      'geohash': geohash,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory DeliverymenModel.fromMap(Map<String, dynamic> map) {
    return DeliverymenModel(
      id: map['id'] as String,
      geopoint: map['geopoint'] as GeoPoint,
      geohash: map['geohash'] as String,
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
        ' geopoint: $geopoint,'
        ' geohash: $geohash,'
        ' updatedAt: $updatedAt,'
        ' createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant DeliverymenModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.geopoint == geopoint &&
        other.geohash == geohash &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        geopoint.hashCode ^
        geohash.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode;
  }
}
