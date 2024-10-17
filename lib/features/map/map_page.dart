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

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/common/models/delivery.dart';
import 'map_controller.dart';

class MapPage extends StatefulWidget {
  final DeliveryModel delivery;

  const MapPage(
    this.delivery, {
    super.key,
  });

  static const routeName = '/map';

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final ctrl = MapController();
  late final LatLng position;
  late final LatLng destiny;

  @override
  void initState() {
    super.initState();

    position = LatLng(
      widget.delivery.shopLocation.latitude,
      widget.delivery.shopLocation.longitude,
    );
    destiny = LatLng(
      widget.delivery.clientLocation.latitude,
      widget.delivery.clientLocation.longitude,
    );
  }

  void _backPage() {
    Navigator.of(context).pop();
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
      body: GoogleMap(
        onMapCreated: ctrl.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: position,
          zoom: 12,
        ),
        markers: {
          Marker(
            markerId: MarkerId(widget.delivery.shopName),
            position: position,
            infoWindow: const InfoWindow(title: 'Loja'),
          ),
          Marker(
            markerId: MarkerId(widget.delivery.clientName),
            position: destiny,
            infoWindow: const InfoWindow(title: 'Client'),
          ),
        },
      ),
    );
  }
}
