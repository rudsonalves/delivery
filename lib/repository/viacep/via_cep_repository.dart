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
      return DataResult.failure(const APIFailure('connection error'));
    }
    final map = json.decode(response.body) as Map<String, dynamic>;
    if (map['error'] == true) {
      return DataResult.failure(const APIFailure('error with query'));
    }

    final addressCep = ViaCepAddressModel.fromPtMap(map);
    return DataResult.success(addressCep);
  }

  static String _cleanCEP(String cep) {
    return cep.replaceAll(RegExp(r'[^\d]'), '');
  }
}
