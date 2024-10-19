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

import '/common/theme/app_text_style.dart';
import '../../../locator.dart';
import '../../../services/navigation_route.dart';
import 'delivery_map_controller.dart';
import 'delivery_map_store.dart';

class DeliveryMapPage extends StatefulWidget {
  const DeliveryMapPage({
    super.key,
  });

  static const routeName = '/delivey_map';

  @override
  State<DeliveryMapPage> createState() => _DeliveryMapPageState();
}

class _DeliveryMapPageState extends State<DeliveryMapPage> {
  final ctrl = DeliveryMapController();
  final navRoute = locator<NavigationRoute>();
  final store = DeliveryMapStore();

  @override
  void initState() {
    super.initState();
    ctrl.init(
      store: store,
    );
  }

  @override
  void dispose() {
    store.dispose();
    ctrl.dispose();

    super.dispose();
  }

  void _backPage() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          Wrap(
            alignment: WrapAlignment.spaceAround,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                tooltip: 'Reiniciar',
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    '01',
                    style: AppTextStyle.font14Bold(),
                  ),
                ),
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
              ctrl.createNumberedMarker(0),
              ...navRoute.orderIds.asMap().entries.map((entry) async {
                return await ctrl.createNumberedMarker(entry.key + 1);
              }),
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return Expanded(
                child: GoogleMap(
                  onMapCreated: ctrl.onMapCreated,
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
