// ignore_for_file: public_member_api_docs, sort_constructors_first
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

import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/utils/late_final.dart';
import '/services/extensions_services.dart';
import '/services/remote_config.dart';
import '../../../common/models/delivery.dart';
import '../../../locator.dart';
import '../../../services/navigation_route.dart';
import '../../../stores/common/store_func.dart';
import 'delivery_map_store.dart';

class DeliveryMapController {
  final navRoute = locator<NavigationRoute>();

  late final DeliveryMapStore store;
  final mapController = LateFinal<GoogleMapController>();
  late List<DeliveryModel> deliveries;

  bool isStarted = false;

  final googleApiKey = LateFinal<String>();
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};

  void init({
    required DeliveryMapStore store,
    required List<DeliveryModel> deliveries,
  }) {
    this.store = store;
    this.deliveries = deliveries;

    createBasicRoutes();
  }

  void dispose() {
    mapController.value.dispose();
  }

  void reversedOrder() {
    store.setPageState(PageState.loading);
    navRoute.reversedOrder();
    store.setPageState(PageState.success);
  }

  void changeOrder(int selectedIndex) {
    final replaceIndex = store.count.value - 1;
    store.incrementCount();
    if (replaceIndex == selectedIndex) return;

    store.setPageState(PageState.loading);
    navRoute.swapOrderIds(replaceIndex, selectedIndex);
    store.setPageState(PageState.success);
  }

  Future<void> createBasicRoutes() async {
    try {
      store.setPageState(PageState.initial);
      var result = await navRoute.setDeliveries(deliveries);
      if (result.isFailure) {
        throw Exception(result.error);
      }
      result = await navRoute.createBasicRoute();
      if (result.isFailure) {
        throw Exception(result.error);
      }
      store.setPageState(PageState.success);
    } catch (err) {
      final message = 'createBasicRoute error: $err';
      log(message);
      store.setError('Erro na determinação de sua localização.');
    }
  }

  void onMapCreated(GoogleMapController controller) {
    if (mapController.isInitialized) return;
    mapController.value = controller;
  }

  Future<BitmapDescriptor> createNumberedMarker(int index) async {
    // Load the marker's base image
    ByteData data = await rootBundle.load('assets/images/pin.png');
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 22, targetHeight: 32);
    FrameInfo fi = await codec.getNextFrame();

    // Start the drawing process
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint();

    // Draw the base marker
    canvas.drawImage(fi.image, Offset.zero, paint);

    // Draw the dot for the number
    double circleSize = (index == 0) ? 19.0 : 16.0;
    final Paint circlePaint = Paint()
      ..color = index == 0 ? const Color(0xFF1A57C0) : Colors.transparent;
    canvas.drawCircle(
      Offset(fi.image.width / 2, fi.image.height / 3.1),
      circleSize / 2,
      circlePaint,
    );

    // Draw the number on the ball
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      text: TextSpan(
        text: index.toString(),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (fi.image.width - textPainter.width) / 2,
        (fi.image.height / 3.0) - textPainter.height / 2,
      ),
    );

    // Convert the drawing to a BitmapDescriptor
    final img = await pictureRecorder
        .endRecording()
        .toImage(fi.image.width, fi.image.height);
    final dataBytes = await img.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.bytes(dataBytes!.buffer.asUint8List());
  }

  Future<void> fetchGoogleRoute() async {
    try {
      store.setPageState(PageState.loading);
      final remoteConfig = locator<RemoteConfig>();

      if (!googleApiKey.isInitialized) {
        googleApiKey.value = await remoteConfig.googleApi;
      }
      if (googleApiKey.value.isEmpty) {
        throw Exception('Google API Key not found!');
      }
      await _getPolyline();
      store.setPageState(PageState.success);
    } catch (err) {
      log(err.toString());
      store.setError(err.toString());
    }
  }

  Future<void> _getPolyline() async {
    final polylinePoints = PolylinePoints();
    final PolylineResult result =
        await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey.value,
      request: PolylineRequest(
        origin: navRoute.startLatLng.pointLatLng(),
        destination: navRoute.orderIds.isNotEmpty
            ? navRoute.lastLatLng.pointLatLng()
            : navRoute.startLatLng.pointLatLng(),
        wayPoints: navRoute.orderIds
            .map(
              (id) => PolylineWayPoint(
                location:
                    '${navRoute.deliveries[id]!.clientLocation.latLng().latitude},'
                    '${navRoute.deliveries[id]!.clientLocation.latLng().longitude}',
              ),
            )
            .toList(),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }

      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: polylineCoordinates,
        ),
      );
    } else {
      throw Exception('Error ou buscar a rota: ${result.errorMessage}');
    }
  }
}
