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

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../locator.dart';
import '../../../services/navigation_route.dart';

class DeliveryMapPage extends StatefulWidget {
  const DeliveryMapPage({
    super.key,
  });

  static const routeName = '/delivey_map';

  @override
  State<DeliveryMapPage> createState() => _DeliveryMapPageState();
}

class _DeliveryMapPageState extends State<DeliveryMapPage> {
  final navRoute = locator<NavigationRoute>();
  late final GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
  }

  void _backPage() {
    Navigator.of(context).pop();
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
    const double circleSize = 16.0;
    final Paint circlePaint = Paint()
      ..color = index == 0 ? Colors.black : Colors.transparent;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delevery Map'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Column(
        children: [
          OverflowBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                tooltip: 'Reiniciar',
              ),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.auto_fix_high_outlined),
                tooltip: 'Auto',
              ),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.done_rounded),
                tooltip: 'Navegar',
              ),
            ],
          ),
          FutureBuilder<List<BitmapDescriptor>>(
            future: Future.wait([
              createNumberedMarker(0),
              ...navRoute.orderIds.asMap().entries.map((entry) async {
                return await createNumberedMarker(entry.key + 1);
              }),
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return Expanded(
                child: GoogleMap(
                  onMapCreated: onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: navRoute.startLatLng,
                    zoom: 12,
                  ),
                  markers: {
                    // Marker para o ponto inicial, usando um ícone azul padrão
                    Marker(
                      markerId: const MarkerId('start'),
                      position: navRoute.startLatLng,
                      icon: snapshot.data![0],
                      infoWindow: const InfoWindow(title: 'Localização atual'),
                    ),
                    // Markers para as entregas, com ícones numerados
                    ...navRoute.orderIds.asMap().entries.map((entry) {
                      int index = entry.key;
                      String id = entry.value;
                      String label = navRoute.deliveries[id]!.clientName;
                      return Marker(
                        markerId: MarkerId(label),
                        position: navRoute.deliveries[id]!.latLng,
                        icon:
                            snapshot.data![index + 1], // Usa o ícone com número
                        infoWindow: InfoWindow(title: label),
                        onTap: () {},
                      );
                    }).toSet(),
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
