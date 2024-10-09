import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../common/utils/data_result.dart';
import '../../locator.dart';
import '../../repository/firebase_store/abstract_deliverymen_repository.dart';
import '../../repository/firebase_store/deliverymen_firebase_repository.dart';
import '../../stores/user/user_store.dart';
import '/stores/common/store_func.dart';
import '../../common/models/delivery_men.dart';
import '../../repository/firebase_store/abstract_deliveries_repository.dart';
import '/common/models/delivery.dart';
import '/repository/firebase_store/deliveries_firebase_repository.dart';
import 'stores/user_delivery_store.dart';

class UserDeliveryController {
  StreamSubscription<List<DeliveryModel>>? _deliveriesSubscription;
  final user = locator<UserStore>();

  final AbstractDeliverymenRepository deliverymenRepository =
      DeliverymenFirebaseRepository();
  final AbstractDeliveriesRepository deliveriesRepository =
      DeliveriesFirebaseRepository();

  // Method to unsubscribe from the stream when it is no longer needed
  void dispose() {
    _deliveriesSubscription?.cancel();
  }

  late final UserDeliveryStore store;
  late String userId;

  // Method to inicialize location and search for deliveries
  Future<void> init({
    required UserDeliveryStore store,
    required String userId,
    required double radiusInKm,
  }) async {
    this.userId = userId;
    this.store = store;

    try {
      DataResult<DeliverymenModel> result;
      if (user.deliverymen == null) {
        final deliverymen = DeliverymenModel(
          id: userId,
          location: const GeoFirePoint(GeoPoint(0, 0)),
        );

        result = await deliverymenRepository.add(deliverymen);
        if (result.isFailure) {
          const message = 'Sua localização não pode ser determinada!';
          log(message);
          store.setError(message);
          return;
        }
      } else {
        // Get and update location in Firebase
        result = await deliverymenRepository.updateLocation(user.deliverymen!);
        if (result.isFailure) {
          const message = 'Não foi possível obter sua localização.';
          log(message);
          store.setError(message);
          return;
        }
      }

      user.deliverymen = result.data!;

      // Start the stream to get nearby deliveries
      _deliveriesSubscription?.cancel(); // Cancel any previous subscriptions
      _deliveriesSubscription = deliveriesRepository
          .getNearby(
        geopoint: user.deliverymen!.location.geopoint,
        radiusInKm: radiusInKm,
      )
          .listen(
        (List<DeliveryModel> fetchedDeliveries) {
          store.setDeliveries(fetchedDeliveries);
          store.setState(PageState.success);
        },
        onError: (error) {
          final message = 'Erro ao buscar entregas próximas: $error';
          log(message);
          store.setError(message);
        },
      );
    } catch (err) {
      final message = 'Error ao inicializar: $err';
      log(message);
      store.setError(message);
    }
  }

  // Method to manually update location and re-fetch deliveries
  Future<void> refresh(double radiusInKm) async {
    store.setState(PageState.loading);
    try {
      // Get and Update location in Firebase
      final result =
          await deliverymenRepository.updateLocation(user.deliverymen!);
      if (result.isFailure) {
        store.setError('Não foi possível obter sua localização.');
        return;
      }
      user.deliverymen = result.data!;

      // Start the stream to get nearby deliveries
      _deliveriesSubscription?.cancel(); // Cancel any previous subscriptions
      _deliveriesSubscription = deliveriesRepository
          .getNearby(
        geopoint: user.deliverymen!.location.geopoint,
        radiusInKm: radiusInKm,
      )
          .listen((List<DeliveryModel> fetchedDeliveries) {
        store.setDeliveries(fetchedDeliveries);
        store.setState(PageState.success);
      }, onError: (error) {
        store.setError('Erro ao buscar entregas próximas: $error');
      });
    } catch (err) {
      store.setError('Erro ao atualizar: $err');
    }
  }

  // Update search radius
  void updateRadius(double newRadius) {
    store.setRadius(newRadius);
    refresh(newRadius);
  }
}
