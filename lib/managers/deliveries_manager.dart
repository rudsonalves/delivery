import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import 'package:delivery/common/models/delivery_extended.dart';

import '../common/models/delivery.dart';
import '../common/models/delivery_men.dart';
import '../features/user_delivery/stores/user_delivery_store.dart';
import '../locator.dart';
import '../repository/firebase_store/abstract_deliveries_repository.dart';
import '../repository/firebase_store/abstract_deliverymen_repository.dart';
import '../repository/firebase_store/deliveries_firebase_repository.dart';
import '../repository/firebase_store/deliverymen_firebase_repository.dart';
import '../stores/common/store_func.dart';
import '../stores/user/user_store.dart';

class DeliveriesManager {
  final UserDeliveryStore store;

  DeliveriesManager({
    required this.store,
  });

  final AbstractDeliverymenRepository deliverymenRepository =
      DeliverymenFirebaseRepository();
  final AbstractDeliveriesRepository deliveriesRepository =
      DeliveriesFirebaseRepository();
  final user = locator<UserStore>();

  StreamSubscription<List<DeliveryExtended>>? _deliveriesSubscription;

  String get userId => user.id!;

  void dispose() {
    _deliveriesSubscription?.cancel();
  }

  Future<void> getNearbyDeliveries() async {
    store.setState(PageState.loading);
    try {
      if (user.deliverymen == null) {
        await _startUserLocation();
      } else {
        await _updateUserLocation();
      }

      _processeNearbyDeliveries();

      return;
    } catch (err) {
      final message = 'Error ao inicializar: $err';
      log(message);
      return;
    }
  }

  Future<void> refreshNearbyDeliveries() async {
    store.setState(PageState.loading);
    try {
      // Get and update location in Firebase
      await _updateUserLocation();

      _processeNearbyDeliveries();

      return;
    } catch (err) {
      final message = 'Error ao inicializar: $err';
      log(message);
      return;
    }
  }

  Future<void> changeStatus(DeliveryModel delivery) async {
    store.setState(PageState.loading);
    delivery.status =
        (delivery.status == DeliveryStatus.orderRegisteredForPickup)
            ? DeliveryStatus.orderReservedForPickup
            : DeliveryStatus.orderRegisteredForPickup;

    final DeliveryModel updatedDelivery =
        delivery.status == DeliveryStatus.orderReservedForPickup
            ? delivery.copyWith(
                deliveryId: userId,
                deliveryName: user.currentUser!.name,
                deliveryPhone: user.currentUser!.phone,
                updatedAt: DateTime.now(),
              )
            : delivery.copyWith(
                deliveryId: '',
                deliveryName: '',
                deliveryPhone: '',
                updatedAt: DateTime.now(),
              );

    await deliveriesRepository.updateStatus(updatedDelivery);
    store.setState(PageState.success);
  }

  void _processeNearbyDeliveries() {
    // Transform the Stream<List<DeliveryModel>> into Stream<List<DeliveryExtended>>
    final Stream<List<DeliveryExtended>> extendedDeliveriesStream =
        _mapExtendedDeliveriesStream();

    // Start the stream to get nearby deliveries
    _deliveriesSubscription?.cancel(); // Cancel any previous subscriptions

    // Subscribe to the transformed stream
    _deliveriesSubscription =
        _listenExtendedDeliveriesStream(extendedDeliveriesStream);
  }

  Future<void> _startUserLocation() async {
    final deliverymen = DeliverymenModel(
      id: userId,
      location: const GeoFirePoint(GeoPoint(0, 0)),
    );

    final result = await deliverymenRepository.set(deliverymen);
    if (result.isFailure) {
      const message = 'Sua localização não pode ser determinada!';
      log(message);
      store.setError(message);
      return;
    }

    user.deliverymen = result.data!;
  }

  Future<void> _updateUserLocation() async {
    final result =
        await deliverymenRepository.updateLocation(user.deliverymen!);
    if (result.isFailure) {
      const message = 'Não foi possível obter sua localização.';
      log(message);
      store.setError(message);
      return;
    }

    user.deliverymen = result.data!;
  }

  Stream<List<DeliveryExtended>> _mapExtendedDeliveriesStream() {
    return deliveriesRepository
        .getNearby(
            geopoint: user.deliverymen!.location.geopoint,
            radiusInKm: store.radiusInKm)
        .map((List<DeliveryModel> deliveries) {
      return deliveries.map((delivery) {
        final distance = _calculateDistance(
          user.deliverymen!.location.geopoint,
          delivery.shopLocation.geopoint,
        );

        return DeliveryExtended.fromDeliveryModel(delivery, distance);
      }).toList();
    });
  }

  StreamSubscription<List<DeliveryExtended>> _listenExtendedDeliveriesStream(
      Stream<List<DeliveryExtended>> extendedDeliveriesStream) {
    return extendedDeliveriesStream.listen(
      (List<DeliveryExtended> fetchedDeliveries) {
        // Use the store to set the deliveries in the application state
        store.setDeliveries(fetchedDeliveries);
        store.setState(PageState.success);
      },
      onError: (error) {
        final message = 'Erro ao buscar entregas próximas: $error';
        log(message);
        store.setError(message);
      },
    );
  }

  double _calculateDistance(GeoPoint start, GeoPoint end) {
    // Aproximadamente o número de km por grau de latitude
    const double kmPerDegreeLat = 111.32;
    // Aproximadamente o número de km por grau de longitude no equador
    const double kmPerDegreeLonAtEquator = 111.32;

    double deltaLat = (end.latitude - start.latitude) * kmPerDegreeLat;
    double deltaLon = (end.longitude - start.longitude) *
        (kmPerDegreeLonAtEquator * math.cos(start.latitude * math.pi / 180));

    return math.sqrt(deltaLat * deltaLat + deltaLon * deltaLon);
  }
}
