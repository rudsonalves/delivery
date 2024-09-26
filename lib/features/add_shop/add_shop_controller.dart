import 'package:delivery/components/custons_text_controllers/masked_text_controller.dart';
import 'package:flutter/material.dart';

import '../../common/models/shop.dart';
import '../../common/utils/data_result.dart';
import '../../stores/pages/common/store_func.dart';
import '../../stores/pages/add_shop_store.dart';

class AddShopController {
  final pageStore = AddShopStore();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(##) #####-####');
  final cepController = MaskedTextController(mask: '##.###-###');
  final numberController = TextEditingController();
  final complementController = TextEditingController();

  bool get isEdited => pageStore.isEdited;
  bool get isValid => pageStore.isValid();
  PageState get state => pageStore.state;

  Future<DataResult<ShopModel?>> saveShop() async => await pageStore.saveShop();
  Future<DataResult<ShopModel?>> updateShop() async =>
      await pageStore.updateShop();

  bool isAddMode = true;

  void init(ShopModel? shop) {
    if (shop != null) {
      pageStore.setShopFromShop(shop);
      nameController.text = shop.name;
      phoneController.text = shop.phone;
      descriptionController.text = shop.description ?? '';
      pageStore.addressType = shop.address?.type ?? 'Comercial';
      cepController.text = shop.address?.zipCode ?? '';
      numberController.text = shop.address?.number ?? '';
      complementController.text = shop.address?.complement ?? '';
      isAddMode = false;
    }
  }

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    cepController.dispose();
    numberController.dispose();
    complementController.dispose();
    descriptionController.dispose();
  }

  void setManager(Map<String, dynamic> manager) {
    pageStore.setManager(manager);
  }
}
