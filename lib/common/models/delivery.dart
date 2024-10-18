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

import 'functions/model_functions.dart';

enum DeliveryStatus {
  orderRegisteredForPickup, // 0
  orderReservedForPickup, // 1
  orderPickedUpForDelivery, // 2
  orderInTransit, // 3
  orderDelivered, // 4
  orderReject, // 5
  orderClosed, // 6
}

class DeliveryModel {
  String? id;
  bool selected;
  String ownerId;
  String shopId;
  String shopName;
  String shopPhone;
  String shopAddress;
  GeoFirePoint shopLocation;
  String clientId;
  String clientName;
  String clientPhone;
  String clientAddress;
  GeoFirePoint clientLocation;
  String? deliveryId;
  String? deliveryName;
  String? deliveryPhone;
  String? managerId;
  DeliveryStatus status;
  DateTime? createdAt;
  DateTime? updatedAt;

  DeliveryModel({
    this.id,
    this.selected = false,
    required this.ownerId,
    required this.shopId,
    required this.shopName,
    required this.shopPhone,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    this.deliveryId,
    this.deliveryName,
    this.deliveryPhone,
    this.managerId,
    required this.status,
    required this.clientAddress,
    required this.shopAddress,
    required this.clientLocation,
    required this.shopLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  DeliveryModel copyWith({
    String? id,
    String? ownerId,
    String? shopId,
    String? shopName,
    String? shopPhone,
    String? clientId,
    String? clientName,
    String? clientPhone,
    String? deliveryId,
    String? deliveryName,
    String? deliveryPhone,
    String? managerId,
    DeliveryStatus? status,
    String? clientAddress,
    String? shopAddress,
    GeoFirePoint? clientLocation,
    GeoFirePoint? shopLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      shopPhone: shopPhone ?? this.shopPhone,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      deliveryId: deliveryId ?? this.deliveryId,
      deliveryName: deliveryName ?? this.deliveryName,
      deliveryPhone: deliveryPhone ?? this.deliveryPhone,
      managerId: managerId ?? this.managerId,
      status: status ?? this.status,
      clientAddress: clientAddress ?? this.clientAddress,
      shopAddress: shopAddress ?? this.shopAddress,
      clientLocation: clientLocation ?? this.clientLocation,
      shopLocation: shopLocation ?? this.shopLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'shopId': shopId,
      'shopName': shopName,
      'shopPhone': shopPhone,
      'clientId': clientId,
      'clientName': clientName,
      'clientPhone': clientPhone,
      'deliveryId': deliveryId,
      'deliveryName': deliveryName,
      'deliveryPhone': deliveryPhone,
      'managerId': managerId,
      'status': status.index,
      'clientAddress': clientAddress,
      'shopAddress': shopAddress,
      'clientLocation': clientLocation.data,
      'shopLocation': shopLocation.data,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory DeliveryModel.fromMap(Map<String, dynamic> map) {
    return DeliveryModel(
      id: map['id'] as String?,
      ownerId: map['ownerId'] as String,
      shopId: map['shopId'] as String,
      shopName: map['shopName'] as String,
      shopPhone: map['shopPhone'] as String,
      clientId: map['clientId'] as String,
      clientName: map['clientName'] as String,
      clientPhone: map['clientPhone'] as String,
      deliveryId: map['deliveryId'] as String?,
      deliveryName: map['deliveryName'] as String?,
      deliveryPhone: map['deliveryPhone'] as String?,
      managerId: map['managerId'] as String?,
      status: DeliveryStatus.values[map['status'] as int],
      clientAddress: map['clientAddress'] as String,
      shopAddress: map['shopAddress'] as String,
      clientLocation:
          mapToGeoFirePoint(map['clientLocation'] as Map<String, dynamic>),
      shopLocation:
          mapToGeoFirePoint(map['shopLocation'] as Map<String, dynamic>),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryModel.fromJson(String source) =>
      DeliveryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryModel(id: $id,'
        ' ownerId: $ownerId,'
        ' shopId: $shopId,'
        ' shopName: $shopName,'
        ' shopPhone: $shopPhone,'
        ' clientId: $clientId,'
        ' clientName: $clientName,'
        ' clientPhone: $clientPhone,'
        ' deliveryId: $deliveryId,'
        ' deliveryName: $deliveryName,'
        ' deliveryPhone: $deliveryPhone,'
        ' managerId: $managerId,'
        ' status: $status,'
        ' clientAddress: $clientAddress,'
        ' shopAddress: $shopAddress,'
        ' clientLocation: $clientLocation,'
        ' shopLocation: $shopLocation,'
        ' createdAt: $createdAt,'
        ' updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant DeliveryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ownerId == ownerId &&
        other.shopId == shopId &&
        other.shopName == shopName &&
        other.shopPhone == shopPhone &&
        other.clientId == clientId &&
        other.clientName == clientName &&
        other.clientPhone == clientPhone &&
        other.deliveryId == deliveryId &&
        other.deliveryName == deliveryName &&
        other.deliveryPhone == deliveryPhone &&
        other.managerId == managerId &&
        other.status == status &&
        other.clientAddress == clientAddress &&
        other.shopAddress == shopAddress &&
        other.clientLocation == clientLocation &&
        other.shopLocation == shopLocation &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ownerId.hashCode ^
        shopId.hashCode ^
        shopName.hashCode ^
        shopPhone.hashCode ^
        clientId.hashCode ^
        clientName.hashCode ^
        clientPhone.hashCode ^
        deliveryId.hashCode ^
        deliveryName.hashCode ^
        deliveryPhone.hashCode ^
        managerId.hashCode ^
        status.hashCode ^
        clientAddress.hashCode ^
        shopAddress.hashCode ^
        clientLocation.hashCode ^
        shopLocation.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
