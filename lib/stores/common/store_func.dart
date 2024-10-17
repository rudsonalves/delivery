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

import '../../common/models/via_cep_address.dart';
import '../../repository/viacep/via_cep_repository.dart';

enum PageState { initial, loading, success, error }

enum ZipStatus { initial, loading, success, error }

const addressTypes = [
  'Apartamento',
  'Clínica',
  'Comercial',
  'Escritório',
  'Residencial',
  'Trabalho',
];

class StoreFunc {
  StoreFunc._();

  static bool itsNotEmail(String? email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return (email == null || email.isEmpty || !regex.hasMatch(email));
  }

  static String? validCpf(String? cpf) {
    if (cpf == null || cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    int digit1 = _calculateDigit(cpf.substring(0, 9), 10);
    int digit2 = _calculateDigit(cpf.substring(0, 10), 11);

    bool valid = digit1 == int.parse(cpf[9]) && digit2 == int.parse(cpf[10]);
    if (!valid) {
      return 'CPF inválido';
    }
    return null;
  }

  static int _calculateDigit(String cpf, int factor) {
    int total = 0;
    for (int i = 0; i < cpf.length; i++) {
      total += int.parse(cpf[i]) * factor--;
    }
    int rest = total % 11;
    return (rest < 2) ? 0 : 11 - rest;
  }

  static Future<(ZipStatus, String?, ViaCepAddressModel?)> fetchAddress(
      String? zipCode) async {
    try {
      final response = await ViaCepRepository.getLocalByCEP(zipCode!);
      if (!response.isSuccess) {
        return (ZipStatus.error, 'CEP inválido', null);
      }

      final viaAddress = response.data;
      if (viaAddress == null) {
        return (ZipStatus.error, 'CEP inválido', null);
      }

      return (ZipStatus.success, null, viaAddress);
    } catch (err) {
      return (ZipStatus.error, 'erro desconhecido: $err', null);
    }
  }
}
