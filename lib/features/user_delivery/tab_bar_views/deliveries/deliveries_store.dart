import 'package:flutter/foundation.dart';

import '../../../../common/models/delivery.dart';
import '../../../../stores/common/store_func.dart';

class DeliveriesStore {
  final state = ValueNotifier<PageState>(PageState.initial);

  final List<DeliveryModel> deliveries = [];

  String? errorMessage;

  void setPageState(PageState newState) {
    state.value = newState;
  }

  void setDeliveries(List<DeliveryModel> newDeliveries) {
    deliveries.clear();
    deliveries.addAll(newDeliveries);
  }

  void dispose() {
    state.dispose();
  }

  void setError(String? err) {
    errorMessage = err;
    setPageState(PageState.error);
  }
}
