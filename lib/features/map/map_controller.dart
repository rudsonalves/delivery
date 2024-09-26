import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController {
  late final GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
