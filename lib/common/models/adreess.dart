class AddressModel {
  String? id;
  String zipCode;
  String street;
  String number;
  String? complement;
  String neighborhood;
  String state;
  String city;
  DateTime createdAt;

  AddressModel({
    this.id,
    required this.zipCode,
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.state,
    required this.city,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String addressString() {
    return '$street, '
        'N° $number, '
        '${complement != null && complement!.isNotEmpty ? 'Complemento $complement, ' : ''}'
        'Bairro $neighborhood, '
        '$city - $state, '
        'CEP: $zipCode';
  }

  @override
  String toString() {
    return 'AddressModel(id: $id,'
        ' zipCode: $zipCode,'
        ' street: $street,'
        ' number: $number,'
        ' complement: $complement,'
        ' neighborhood: $neighborhood,'
        ' state: $state,'
        ' city: $city,'
        ' createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.zipCode == zipCode &&
        other.street == street &&
        other.number == number &&
        other.complement == complement &&
        other.neighborhood == neighborhood &&
        other.state == state &&
        other.city == city &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        zipCode.hashCode ^
        street.hashCode ^
        number.hashCode ^
        complement.hashCode ^
        neighborhood.hashCode ^
        state.hashCode ^
        city.hashCode ^
        createdAt.hashCode;
  }

  AddressModel copyWith({
    String? id,
    String? zipCode,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? state,
    String? city,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      zipCode: zipCode ?? this.zipCode,
      street: street ?? this.street,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      state: state ?? this.state,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'zipCode': zipCode,
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'state': state,
      'city': city,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] != null ? map['id'] as String : null,
      zipCode: map['zipCode'] as String,
      street: map['street'] as String,
      number: map['number'] as String,
      complement:
          map['complement'] != null ? map['complement'] as String : null,
      neighborhood: map['neighborhood'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
}
