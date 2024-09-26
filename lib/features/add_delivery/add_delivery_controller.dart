import 'package:flutter/material.dart';

import '/components/custons_text_controllers/masked_text_controller.dart';
import '/stores/pages/common/store_func.dart';
import '../../common/models/client.dart';
import '../../common/models/shop.dart';
import '../../stores/pages/add_delivery_store.dart';

class AddDeliveryController {
  final pageStore = AddDeliveryStore();

  final phoneController = MaskedTextController(mask: '(##) #####-####');
  final nameController = TextEditingController();

  List<ShopModel> get shops => pageStore.shops;
  List<ClientModel> get clients => pageStore.clients;
  ClientModel? get selectedClient => pageStore.selectedClient;
  PageState get state => pageStore.state;
  String? get selectedShopId => pageStore.shopId;
  SearchMode get searchBy => pageStore.searchBy;
  NoShopState get noShopsState => pageStore.noShopsState;

  void toogleSearchBy() => pageStore.toogleSearchBy();
  void selectClient(ClientModel client) => pageStore.selectClient(client);
  Future<void> createDelivery() => pageStore.createDelivery();

  Future<void> init() async {
    await pageStore.init();
  }

  void dispose() {
    phoneController.dispose();
    nameController.dispose();
  }
}
