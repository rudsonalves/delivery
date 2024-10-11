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
    _setLoadingState();
    try {
      if (user.deliverymen == null) {
        await _startUserLocation();
      } else {
        await _updateUserLocation();
      }
      _processeNearbyDeliveries();
    } catch (err) {
      _setErrorState('Error ao inicializar: $err');
    }
  }

  Future<void> refreshNearbyDeliveries() async {
    _setLoadingState();
    try {
      await _updateUserLocation();
      _processeNearbyDeliveries();
    } catch (err) {
      _setErrorState('Error ao inicializar: $err');
    }
  }

  Future<void> changeDeliveryStatus(DeliveryModel delivery) async {
    _setLoadingState();
    final updatedDelivery = _getUpdatedDeliveryStatus(delivery);
    await deliveriesRepository.updateStatus(updatedDelivery);
    store.setState(PageState.success);
  }

  void _processeNearbyDeliveries() {
    final Stream<List<DeliveryExtended>> extendedDeliveriesStream =
        _mapExtendedDeliveriesStream();

    _deliveriesSubscription?.cancel();
    _subscribeToDeliveries(extendedDeliveriesStream);
  }

  Future<void> _startUserLocation() async {
    final deliverymen = DeliverymenModel(
      id: userId,
      location: const GeoFirePoint(GeoPoint(0, 0)),
    );

    final result = await deliverymenRepository.set(deliverymen);
    if (result.isFailure) {
      _setErrorState('Sua localização não pode ser determinada!');
      return;
    }
    user.deliverymen = result.data!;
  }

  Future<void> _updateUserLocation() async {
    final result =
        await deliverymenRepository.updateLocation(user.deliverymen!);
    if (result.isFailure) {
      _setErrorState('Não foi possível obter sua localização.');
      return;
    }
    user.deliverymen = result.data!;
  }

  Stream<List<DeliveryExtended>> _mapExtendedDeliveriesStream() {
    return deliveriesRepository
        .getNearby(
            geopoint: user.deliverymen!.location.geopoint,
            radiusInKm: store.radiusInKm)
        .transform(_deliveryToExtendedTransformer());
  }

  StreamTransformer<List<DeliveryModel>, List<DeliveryExtended>>
      _deliveryToExtendedTransformer() {
    return StreamTransformer.fromHandlers(
      handleData: (List<DeliveryModel> deliveries,
          EventSink<List<DeliveryExtended>> sink) {
        final List<DeliveryExtended> extendedDeliveries =
            deliveries.map((delivery) {
          final distance = _calculateDistance(
            user.deliverymen!.location.geopoint,
            delivery.shopLocation.geopoint,
          );
          return DeliveryExtended.fromDeliveryModel(delivery, distance);
        }).toList();
        sink.add(extendedDeliveries);
      },
    );
  }

  void _subscribeToDeliveries(
      Stream<List<DeliveryExtended>> extendedDeliveriesStream) {
    _deliveriesSubscription = extendedDeliveriesStream.listen(
      (fetchedDeliveries) {
        store.setDeliveries(fetchedDeliveries);
        store.setState(PageState.success);
      },
      onError: (error) {
        _setErrorState('Erro ao buscar entregas próximas: $error');
      },
    );
  }

  DeliveryModel _getUpdatedDeliveryStatus(DeliveryModel delivery) {
    final newStatus = delivery.status == DeliveryStatus.orderRegisteredForPickup
        ? DeliveryStatus.orderReservedForPickup
        : DeliveryStatus.orderRegisteredForPickup;

    return delivery.copyWith(
      status: newStatus,
      deliveryId:
          newStatus == DeliveryStatus.orderReservedForPickup ? userId : '',
      deliveryName: newStatus == DeliveryStatus.orderReservedForPickup
          ? user.currentUser!.name
          : '',
      deliveryPhone: newStatus == DeliveryStatus.orderReservedForPickup
          ? user.currentUser!.phone
          : '',
      updatedAt: DateTime.now(),
    );
  }

  double _calculateDistance(GeoPoint start, GeoPoint end) {
    const double kmPerDegreeLat = 111.32;
    const double kmPerDegreeLonAtEquator = 111.32;

    double deltaLat = (end.latitude - start.latitude) * kmPerDegreeLat;
    double deltaLon = (end.longitude - start.longitude) *
        (kmPerDegreeLonAtEquator * math.cos(start.latitude * math.pi / 180));

    return math.sqrt(deltaLat * deltaLat + deltaLon * deltaLon);
  }

  void _setLoadingState() {
    store.setState(PageState.loading);
  }

  void _setErrorState(String message) {
    log(message);
    store.setError(message);
  }
}
