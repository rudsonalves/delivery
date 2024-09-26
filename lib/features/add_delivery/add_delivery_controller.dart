import 'package:flutter/material.dart';

import '/components/custons_text_controllers/masked_text_controller.dart';
import '/stores/pages/common/store_func.dart';
import '../../common/models/client.dart';
import '../../common/models/shop.dart';
import '../../stores/pages/add_delivery_store.dart';

class AddDeliveryController {
  final store = AddDeliveryStore();

  final phoneController = MaskedTextController(mask: '(##) #####-####');
  final nameController = TextEditingController();

  List<ShopModel> get shops => store.shops;
  List<ClientModel> get clients => store.clients;
  ClientModel? get selectedClient => store.selectedClient;
  PageState get state => store.state;
  String? get selectedShopId => store.shopId;
  SearchMode get searchBy => store.searchBy;
  NoShopState get noShopsState => store.noShopsState;

  void toogleSearchBy() => store.toogleSearchBy();
  void selectClient(ClientModel client) => store.selectClient(client);
  Future<void> createDelivery() => store.createDelivery();

  Future<void> init() async {
    await store.init();
  }

  void dispose() {
    phoneController.dispose();
    nameController.dispose();
  }
}
