import 'dart:async';

import '../../../common/models/delivery.dart';
import '../../../common/models/delivery_info.dart';
import '../../../locator.dart';
import '../../../repository/firebase_store/deliveries_firebase_repository.dart';
import '../../../stores/common/store_func.dart';
import '../../../stores/user/user_store.dart';
import 'manager_store.dart';

class ManagerController {
  StreamSubscription<List<DeliveryModel>>? _deliveriesSubscription;
  final userId = locator<UserStore>().currentUser!.id!;
  late final ManagerStore store;
  final deliveryRepository = DeliveriesFirebaseRepository();
  late final DeliveryStatus deliveryStatus;
  late final Map<String, DeliveryInfoModel> selectedIds;

  void init({
    required ManagerStore store,
    required DeliveryStatus status,
    required Map<String, DeliveryInfoModel> selectedIds,
  }) {
    this.store = store;
    deliveryStatus = status;
    this.selectedIds = selectedIds;
    this.selectedIds.clear();
    _getDeliveries();
  }

  void dispose() {
    _deliveriesSubscription?.cancel();
  }

  void _getDeliveries() {
    store.setPageState(PageState.loading);
    // Cancel any previus subscription
    _deliveriesSubscription?.cancel();
    if (store.shopId != null) {
      _deliveriesSubscription = deliveryRepository
          .getByShopId(
        shopId: store.shopId!,
        status: deliveryStatus,
      )
          .listen((List<DeliveryModel> fetchedDeliveries) {
        store.setPageState(PageState.loading);
        store.setDeliveries(fetchedDeliveries);
        store.setPageState(PageState.success);
      }, onError: (err) {
        store.setPageState(PageState.loading);
        store.setError('Erro ao buscar entregas: $err');
      });
    } else {
      _deliveriesSubscription = deliveryRepository
          .getByManagerId(
        managerId: userId,
        status: deliveryStatus,
      )
          .listen((List<DeliveryModel> fetchedDeliveries) {
        store.setPageState(PageState.loading);
        store.setDeliveries(fetchedDeliveries);
        store.setPageState(PageState.success);
      }, onError: (err) {
        store.setPageState(PageState.loading);
        store.setError('Erro ao buscar entregas: $err');
      });
    }
  }

  void toggleSelection(DeliveryModel delivery) {
    final deliveryId = delivery.id!;
    store.setPageState(PageState.loading);
    if (selectedIds.containsKey(deliveryId)) {
      selectedIds.remove(deliveryId);
    } else {
      selectedIds[deliveryId] = DeliveryInfoModel.fromDelivery(delivery);
    }
    store.setPageState(PageState.success);
  }
}
