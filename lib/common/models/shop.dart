import 'dart:convert';

import 'address.dart';

class ShopModel {
  String? id;
  String userId;
  String? managerId;
  String? managerName;
  AddressModel? address;
  String name;
  String? description;

  ShopModel({
    this.id,
    required this.userId,
    this.managerId,
    this.managerName,
    this.address,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'managerId': managerId,
      'managerName': managerName,
      'name': name,
      'description': description,
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'] as String?,
      userId: map['userId'] as String,
      managerId: map['managerId'] as String?,
      managerName: map['managerName'] as String?,
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
    String? managerId,
    String? managerName,
    AddressModel? address,
    String? name,
    String? description,
  }) {
    return ShopModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
      address: address ?? this.address,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'ShopModel(id: $id,'
        ' userId: $userId,'
        ' managerId: $managerId,'
        ' managerName: $managerName,'
        ' address: $address,'
        ' name: $name,'
        ' description: $description)';
  }
}
