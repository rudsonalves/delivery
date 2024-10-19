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
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/models/delivery.dart';
import '../../../locator.dart';
import '../../../services/navigation_route.dart';
import '../../../stores/common/store_func.dart';
import 'delivery_map_store.dart';

class DeliveryMapController {
  final navRoute = locator<NavigationRoute>();

  late final DeliveryMapStore store;
  late final GoogleMapController mapController;
  late List<DeliveryModel> deliveries;

  void init({
    required DeliveryMapStore store,
    required List<DeliveryModel> deliveries,
  }) {
    this.store = store;
    this.deliveries = deliveries;

    createBasicRoutes();
  }

  void dispose() {
    mapController.dispose();
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
    mapController = controller;
  }

  Future<BitmapDescriptor> createNumberedMarker(int index) async {
    // Load the marker's base image
    ByteData data = await rootBundle.load('assets/images/pin.png');
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 22, targetHeight: 32);
    ui.FrameInfo fi = await codec.getNextFrame();

    // Start the drawing process
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint();

    // Draw the base marker
    canvas.drawImage(fi.image, Offset.zero, paint);

    // Draw the dot for the number
    double circleSize = (index == 0) ? 19.0 : 16.0;
    final Paint circlePaint = Paint()
      ..color = index == 0 ? const ui.Color(0xFF1A57C0) : Colors.transparent;
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
    final dataBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(dataBytes!.buffer.asUint8List());
  }
}
