// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'package:delivery/stores/pages/common/store_func.dart';

import '/common/models/delivery.dart';
import '/repository/firebase_store/deliveries_firebase_repository.dart';
import '/services/location_service.dart';
import '/stores/pages/nearby_deliveries_store.dart';

class NeabyDeliveriesController {
  final NearbyDeliveriesStore store;

  NeabyDeliveriesController({
    required this.store,
  });

  StreamSubscription<List<DeliveryModel>>? _deliveriesSubscription;

  final locationService = LocationService();
  final deliveriesRepository = DeliveriesFirebaseRepository();

  // Method to unsubscribe from the stream when it is no longer needed
  void dispose() {
    _deliveriesSubscription?.cancel();
  }

  // Method to inicialize location and search for deliveries
  Future<void> init(String? userId, double radiusInKm) async {
    if (userId == null) {
      store.setError('Usuário não conectado!');
      return;
    }
    try {
      // Get and update location in Firebase
      final Position? position = await locationService.updateLocation(userId);
      if (position == null) {
        store.setError('Não fio possível obter sua localização.');
        return;
      }

      // Criate a GeoPoint to location
      final GeoPoint currentLocation = GeoPoint(
        position.latitude,
        position.longitude,
      );

      // Start the stream to get nearby deliveries
      _deliveriesSubscription?.cancel(); // Cancel any previous subscriptions
      _deliveriesSubscription = deliveriesRepository
          .getNearby(
        location: currentLocation,
        radiusInKm: radiusInKm,
      )
          .listen(
        (List<DeliveryModel> fetchedDeliveries) {
          store.setDeliveries(fetchedDeliveries);
          store.setPageState(PageState.success);
        },
        onError: (error) {
          store.setError('Erro ao buscar entregas próximas: $error');
        },
      );
    } catch (err) {
      store.setError('Error ao inicializar: $err');
    }
  }

  // Method to manually update location and re-fetch deliveries
  Future<void> refresh(String? userId, double radiusInKm) async {
    store.setPageState(PageState.loading);
    if (userId == null) {
      store.setError('Usuário não conectado!');
      return;
    }
    try {
      // Get and Update location in Firebase
      final Position? position = await locationService.updateLocation(userId);
      if (position == null) {
        store.setError('Não foi possível obter sua localização.');
        return;
      }

      // Criate GeoPoint to location
      GeoPoint currentLocation = GeoPoint(
        position.latitude,
        position.longitude,
      );

      // Start the stream to get nearby deliveries
      _deliveriesSubscription?.cancel(); // Cancel any previous subscriptions
      _deliveriesSubscription = deliveriesRepository
          .getNearby(
        location: currentLocation,
        radiusInKm: radiusInKm,
      )
          .listen((List<DeliveryModel> fetchedDeliveries) {
        store.setDeliveries(fetchedDeliveries);
        store.setPageState(PageState.success);
      }, onError: (error) {
        store.setError('Erro ao buscar entregas próximas: $error');
      });
    } catch (err) {
      store.setError('Erro ao atualizar: $err');
    }
  }

  // Update search radius
  void updateRadius(double newRadius, String userId) {
    store.setRadius(newRadius);
    refresh(userId, newRadius);
  }
}
