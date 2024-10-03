import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geocoding/geocoding.dart';

import '/common/models/address.dart';

class AddressFunctions {
  static const int geoHashLength = 5; // 5km radius

  static Future<AddressModel> createAddress({
    String? id,
    required String type,
    required String zipCode,
    required String street,
    required String number,
    String? complement,
    required String neighborhood,
    required String state,
    required String city,
  }) async {
    final address = AddressModel(
      id: id,
      type: type,
      zipCode: zipCode,
      street: street,
      number: number,
      complement: complement,
      neighborhood: neighborhood,
      state: state,
      city: city,
    );

    final newAddress = updateAddressGeoLocation(address);

    return newAddress;
  }

  static Future<AddressModel> updateAddressGeoLocation(
      AddressModel address) async {
    final newAddress = address.copyWith();

    // Get a new GeoPoint from address
    final geoPoint = await getGeoPointFromAddressString(
      newAddress.geoAddressString,
    );
    if (geoPoint == null) {
      // Create a exception if any error
      throw Exception('Address geoPoint return null');
    }
    // Create a new GeoHash
    final geohash = createGeoPointHash(geoPoint);

    // Update geopoint and geohash at address
    newAddress.geopoint = geoPoint;
    newAddress.geohash = geohash;

    // Update createdAt and updatedAt
    final now = DateTime.now();
    newAddress.createdAt ??= now;
    newAddress.updatedAt = now;

    return newAddress;
  }

  static String createGeoPointHash(GeoPoint geo) {
    return GeoFlutterFire()
        .point(latitude: geo.latitude, longitude: geo.longitude)
        .hash
        .substring(0, geoHashLength);
  }

  static Future<GeoPoint?> getGeoPointFromAddressString(
    String addressString,
  ) async {
    try {
      List<Location> locations = await locationFromAddress(addressString);

      if (locations.isEmpty) {
        throw Exception('No locationfound for the address provided.');
      }

      final location = locations.first;
      return GeoPoint(location.latitude, location.longitude);
    } catch (err) {
      final message =
          'GeolocationServiceGoogle.getCoordinatesFromAddress: $err';
      log(message);
      return null;
    }
  }
}
