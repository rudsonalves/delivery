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
import 'dart:io';

import 'package:http/http.dart' as http;

import '/common/utils/data_result.dart';
import '/common/models/via_cep_address.dart';

class ViaCepRepository {
  ViaCepRepository._();

  static Future<DataResult<ViaCepAddressModel>> getLocalByCEP(
      String cep) async {
    final cleanCEP = _cleanCEP(cep);
    final urlCEP = 'https://viacep.com.br/ws/$cleanCEP/json/';

    final response = await http.get(Uri.parse(urlCEP));
    if (response.statusCode != HttpStatus.ok) {
      return DataResult.failure(const APIFailure(message: 'connection error'));
    }
    final map = json.decode(response.body) as Map<String, dynamic>;
    if (map['error'] == true) {
      return DataResult.failure(const APIFailure(message: 'error with query'));
    }

    final addressCep = ViaCepAddressModel.fromPtMap(map);
    return DataResult.success(addressCep);
  }

  static String _cleanCEP(String cep) {
    return cep.replaceAll(RegExp(r'[^\d]'), '');
  }
}
