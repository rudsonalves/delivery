// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum DeliveryStatus {
  orderRegisteredForPickup,
  orderPickedUpForDelivery,
  orderInTransit,
  orderDelivered,
  orderClosed,
  orderReject,
}

class DeliveryModel {
  String? id;
  String shopId;
  String shopName;
  String clientId;
  String clientName;
  String clientPhone;
  String? deliveryId;
  String? deliveryName;
  String? managerId;
  DeliveryStatus status;
  String clientAddress;
  String shopAddress;
  GeoPoint clientLocation;
  GeoPoint shopLocation;
  DateTime? createdAt;
  DateTime? updatedAt;

  DeliveryModel({
    this.id,
    required this.shopId,
    required this.shopName,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    this.deliveryId,
    this.deliveryName,
    this.managerId,
    required this.status,
    required this.clientAddress,
    required this.shopAddress,
    required this.clientLocation,
    required this.shopLocation,
    this.createdAt,
    this.updatedAt,
  });

  DeliveryModel copyWith({
    String? id,
    String? shopId,
    String? shopName,
    String? clientId,
    String? clientName,
    String? clientPhone,
    String? deliveryId,
    String? deliveryName,
    String? managerId,
    DeliveryStatus? status,
    String? clientAddress,
    String? shopAddress,
    GeoPoint? clientLocation,
    GeoPoint? shopLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      deliveryId: deliveryId ?? this.deliveryId,
      deliveryName: deliveryName ?? this.deliveryName,
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
      'shopId': shopId,
      'shopName': shopName,
      'clientId': clientId,
      'clientName': clientName,
      'clientPhone': clientPhone,
      'deliveryId': deliveryId,
      'deliveryName': deliveryName,
      'managerId': managerId,
      'status': status.index,
      'clientAddress': clientAddress,
      'shopAddress': shopAddress,
      'clientLocation': clientLocation,
      'shopLocation': shopLocation,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory DeliveryModel.fromMap(Map<String, dynamic> map) {
    return DeliveryModel(
      id: map['id'] as String?,
      shopId: map['shopId'] as String,
      shopName: map['shopName'] as String,
      clientId: map['clientId'] as String,
      clientName: map['clientName'] as String,
      clientPhone: map['clientPhone'] as String,
      deliveryId: map['deliveryId'] as String?,
      deliveryName: map['deliveryName'] as String?,
      managerId: map['managerId'] as String?,
      status: DeliveryStatus.values[map['status'] as int],
      clientAddress: map['clientAddress'] as String,
      shopAddress: map['shopAddress'] as String,
      clientLocation: map['clientLocation'] as GeoPoint,
      shopLocation: map['shopLocation'] as GeoPoint,
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
        ' shopId: $shopId,'
        ' shopName: $shopName,'
        ' clientId: $clientId,'
        ' clientName: $clientName,'
        ' clientPhone: $clientPhone,'
        ' deliveryId: $deliveryId,'
        ' deliveryName: $deliveryName,'
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
        other.shopId == shopId &&
        other.shopName == shopName &&
        other.clientId == clientId &&
        other.clientName == clientName &&
        other.clientPhone == clientPhone &&
        other.deliveryId == deliveryId &&
        other.deliveryName == deliveryName &&
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
        shopId.hashCode ^
        shopName.hashCode ^
        clientId.hashCode ^
        clientName.hashCode ^
        clientPhone.hashCode ^
        deliveryId.hashCode ^
        deliveryName.hashCode ^
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
