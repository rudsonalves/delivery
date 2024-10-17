import 'dart:async';

import '../../../../locator.dart';
import '../../../../repository/firebase_store/deliveries_firebase_repository.dart';
import '../../../../stores/user/user_store.dart';
import '/stores/common/store_func.dart';
import '../../../../common/models/delivery.dart';
import 'deliveries_store.dart';

class DeliveriesController {
  final deliveryRepository = DeliveriesFirebaseRepository();
  final user = locator<UserStore>().currentUser!;

  late final DeliveriesStore store;
  StreamSubscription<List<DeliveryModel>>? _deliveriesSubscription;

  void init(DeliveriesStore store) {
    this.store = store;

    _getDeliveries();
  }

  void dispose() {
    _deliveriesSubscription?.cancel();
    _deliveriesSubscription = null;
  }

  void _getDeliveries() {
    store.setPageState(PageState.loading);
    // Cancel previus subscription
    _deliveriesSubscription?.cancel();
    _deliveriesSubscription = deliveryRepository
        .getByDeliveryId(user.id!)
        .listen((List<DeliveryModel> fetchedDeliveries) {
      store.setPageState(PageState.loading);
      store.setDeliveries(fetchedDeliveries);
      store.setPageState(PageState.success);
    }, onError: (err) {
      store.setError('Erro ao buscar entregas: $err');
    });
  }

  Future<void> catchDeliveryById(String deliveryId) async {
    try {
      store.setPageState(PageState.loading);
      await deliveryRepository.updateDeliveryStatus(
        user: user,
        deliveryId: deliveryId,
      );
      store.setPageState(PageState.success);
    } catch (err) {
      store.setError('Erro ao buscar entregas: $err');
    }
  }
}
