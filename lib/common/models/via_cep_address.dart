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

class ViaCepAddressModel {
  final String zipCode;
  final String street;
  final String complement;
  final String unit;
  final String neighborhood;
  final String city;
  final String state;
  final String ibge;
  final String gia;
  final String ddd;
  final String siafi;

  ViaCepAddressModel({
    required this.zipCode,
    required this.street,
    required this.complement,
    required this.unit,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.ibge,
    required this.gia,
    required this.ddd,
    required this.siafi,
  });

  Map<String, dynamic> toPtMap() {
    return <String, dynamic>{
      'cep': zipCode,
      'logradouro': street,
      'complemento': complement,
      'unidade': unit,
      'bairro': neighborhood,
      'localidade': city,
      'uf': state,
      'ibge': ibge,
      'gia': gia,
      'ddd': ddd,
      'siafi': siafi,
    };
  }

  factory ViaCepAddressModel.fromPtMap(Map<String, dynamic> map) {
    return ViaCepAddressModel(
      zipCode: map['cep'] as String,
      street: map['logradouro'] as String,
      complement: map['complemento'] as String,
      unit: map['unidade'] as String,
      neighborhood: map['bairro'] as String,
      city: map['localidade'] as String,
      state: map['uf'] as String,
      ibge: map['ibge'] as String,
      gia: map['gia'] as String,
      ddd: map['ddd'] as String,
      siafi: map['siafi'] as String,
    );
  }

  @override
  String toString() {
    return 'ViaCepAddressModel(zipCode: $zipCode\n'
        ' street: $street\n'
        ' complement: $complement\n'
        ' unit: $unit\n'
        ' neighborhood: $neighborhood\n'
        ' city: $city\n'
        ' state: $state\n'
        ' ibge: $ibge\n'
        ' gia: $gia\n'
        ' ddd: $ddd\n'
        ' siafi: $siafi)';
  }
}
