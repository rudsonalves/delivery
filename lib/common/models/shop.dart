import 'dart:convert';

import 'address.dart';

class ShopModel {
  String? id;
  String userId;
  AddressModel? address;
  String name;
  String? description;

  ShopModel({
    this.id,
    required this.userId,
    this.address,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'address': address?.toMap(),
      'name': name,
      'description': description,
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'] as String?,
      userId: map['userId'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopModel.fromJson(String source) =>
      ShopModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ShopModel copyWith({
    String? id,
    String? userId,
    AddressModel? address,
    String? name,
    String? comments,
  }) {
    return ShopModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      name: name ?? this.name,
      description: comments ?? this.description,
    );
  }

  @override
  String toString() {
    return 'ShopModel(id: $id,'
        ' userId: $userId,'
        ' address: $address,'
        ' name: $name,'
        ' description: $description)';
  }
}
