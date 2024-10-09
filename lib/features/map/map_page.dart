import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/common/models/delivery.dart';
import 'map_controller.dart';

class MapPage extends StatefulWidget {
  final DeliveryModel delivery;

  const MapPage({
    super.key,
    required this.delivery,
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
