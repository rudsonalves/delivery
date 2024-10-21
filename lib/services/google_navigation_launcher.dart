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

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '/services/extensions_services.dart';
import '../locator.dart';
import 'navigation_route.dart';

class GoogleNavigationLauncher {
  /// Start Google Maps navigation using the current navigation route information.
  static Future<void> startNavigation() async {
    final navRoute = locator<NavigationRoute>();
    if (navRoute.orderIds.isEmpty || navRoute.deliveries.isEmpty) {
      throw 'No deliveries or order IDs found for navigation.';
    }

    // Get the origin coordenates (current location os the driver)
    LatLng origin = navRoute.startLatLng;

    // Get the destination coordinates (the last stop)
    LatLng destination = navRoute.lastLatLng;

    // Get the list of intermediate waypoints
    List<LatLng> waypoints = navRoute.orderIds
        .map((id) => navRoute.deliveries[id]!.clientLocation.latLng())
        .toList();

    // Construct the URL to invoke Google Maps
    String googleMapUrl = 'https://www.google.com/maps/dir/?api=1'
        '&origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&travelmode=driving';

    // Add waypoints if any
    if (waypoints.isNotEmpty) {
      String waypointsString = waypoints
          .map((waypoint) => '${waypoint.latitude},${waypoint.longitude}')
          .join('|');
      googleMapUrl += '&waypoints=$waypointsString';
    }

    // Check if the URL can be launched and initiate Google Maps
    final googleUri = Uri.parse(googleMapUrl);
    if (await canLaunchUrl(googleUri)) {
      await launchUrl(googleUri);
    }
  }
}
