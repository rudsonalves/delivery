import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';

/// A class for managing geolocation operations.
class GeoLocation {
  GeoLocation._(); // Private constructor to prevent instantiation.

  /// Obtains the current location as a GeoFirePoint.
  ///
  /// This method handles location permissions, requests the current position
  /// with high accuracy, and returns a [GeoFirePoint] based on the current
  /// coordinates.
  ///
  /// Throws an [Exception] if unable to obtain the geolocation.
  static Future<GeoFirePoint> getCurrentGeoFirePoint() async {
    try {
      // Handle location permissions
      bool hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        throw Exception(
            'LocationService._getCurrentGeoFirePoint: Unable to get geolocation!');
      }

      // Get the current position with high accuracy
      Position? position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Create and return a GeoFirePoint with the current location coordinates
      return GeoFirePoint(GeoPoint(position.latitude, position.longitude));
    } catch (err) {
      throw Exception(
          'LocationService._getCurrentGeoFirePoint: Unable to generate geolocation!');
    }
  }

  /// Checks and requests location permissions.
  ///
  /// Returns `true` if permissions are granted, otherwise `false`.
  static Future<bool> _handleLocationPermission() async {
    try {
      // Check if location services are enabled
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      // Request permission if denied
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      // If permission is denied forever, return false as no location access is possible
      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return true; // Permissions granted
    } catch (err) {
      log('_handleLocationPermission: $err'); // Log the error if any
      return false;
    }
  }

  /// Calculate the distance between two GeoPoints
  ///
  /// This function calculate the distance between two GeoPoits, using a flat
  /// earth approximation. Thia approximation provides good results for
  /// distances below 20km, whitch is the focus this application.
  static double calculateDistance(GeoPoint start, GeoPoint end) {
    const double kmPerDegreeLat = 111.32;
    const double kmPerDegreeLonAtEquator = 111.32;

    double deltaLat = (end.latitude - start.latitude) * kmPerDegreeLat;
    double deltaLon = (end.longitude - start.longitude) *
        (kmPerDegreeLonAtEquator * math.cos(start.latitude * math.pi / 180));

    return math.sqrt(deltaLat * deltaLat + deltaLon * deltaLon);
  }
}
