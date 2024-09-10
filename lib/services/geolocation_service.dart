import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../common/utils/data_result.dart';
import '../locator.dart';
import '/common/models/address.dart';
import 'remote_config.dart';

class GeolocationServiceGoogle {
  static Future<DataResult<AddressModel>> getCoordinatesFromAddress(
    AddressModel address,
  ) async {
    try {
      if (kDebugMode) {
        return DataResult.success(
          address
            ..latitude = -20.361696344914012
            ..longitude = -40.29830324745842,
        );
      }
      final uri = Uri.encodeComponent(address.geoAddress);
      final apiKey = locator<RemoteConfig>().googleApi;
      if (apiKey.isEmpty) {
        throw Exception('google api key not found');
      }
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$uri&key=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('HTTP request error: ${response.statusCode}');
      }

      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] != 'OK') {
        throw Exception('No results found for the address provided.');
      }

      final location = data['results'][0]['geometry']['location'];
      final latitude = location['lat'] as double;
      final longitude = location['lng'] as double;

      return DataResult.success(
          address.copyWith(latitude: latitude, longitude: longitude));
    } catch (err) {
      final message =
          'GeolocationServiceGoogle.getCoordinatesFromAddress: $err';
      log(message);
      return DataResult.failure(APIFailure(message: message));
    }
  }
}
