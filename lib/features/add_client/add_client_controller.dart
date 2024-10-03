import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../common/models/address.dart';
import '../../common/models/client.dart';
import '../../common/models/via_cep_address.dart';
import '../../common/utils/data_result.dart';
import '../../repository/firebase_store/client_firebase_repository.dart';
import '../../stores/pages/common/store_func.dart';
import '/components/custons_text_controllers/masked_text_controller.dart';
import 'stores/add_client_store.dart';

class AddClientController {
  final repository = ClientFirebaseRepository();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(##) #####-####');
  final cepController = MaskedTextController(mask: '##.###-###');
  final numberController = TextEditingController();
  final complementController = TextEditingController();

  late final AddClientStore store;

  ClientModel? client;
  AddressModel? address;
  ReactionDisposer? _disposer;

  void init(AddClientStore newStore, ClientModel? editClient) {
    store = newStore;

    if (editClient != null) {
      client = editClient.copyWith();
      _setClientValues();
    }

    _disposer = reaction<bool>(
      (_) => store.mountAddress,
      (valor) {
        if (valor) {
          _mountAddress();
          store.resetMountAddress();
        }
      },
    );
  }

  void _setClientValues() {
    store.setClientFromClient(client!);

    nameController.text = client!.name;
    emailController.text = client!.email ?? '';
    phoneController.text = client!.phone;
    store.addressType = client!.address?.type ?? 'Residencial';
    cepController.text = client!.address?.zipCode ?? '';
    numberController.text = client!.address?.number ?? '';
    complementController.text = client!.address?.complement ?? '';
    address = client!.address;
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cepController.dispose();
    numberController.dispose();
    complementController.dispose();
    _disposer?.call();
  }

  Future<ClientModel?> getClientFromForm() async {
    store.setState(PageState.loading);
    if (!store.isValid()) {
      store.setError('Verifique os campos obrigatórios (*) do formulário.');
      return null;
    }

    if (address == null) {
      await _mountAddress();
    }
    if (store.updateLocation) {
      address!.complement = store.complement;
      address!.number = store.number!;
      await _setCoordinates();
    }
    address!.type = store.addressType!;

    store.setState(PageState.success);
    return ClientModel(
      id: client?.id,
      name: store.name!,
      email: store.email,
      phone: store.phone!,
      address: address?.copyWith(),
      addressString: address?.geoAddressString,
      geopoint: address?.geopoint,
    );
  }

  Future<void> _setCoordinates() async {
    address = await address!.updateLocation();
    store.resetUpdateLocation();
  }

  Future<void> _mountAddress() async {
    store.setZipStatus(ZipStatus.loading);

    ZipStatus status;
    String? err;
    ViaCepAddressModel? via;
    (status, err, via) = await StoreFunc.fetchAddress(store.zipCode);

    store.setZipStatus(status);
    store.setErrorZipCode(err);

    if (via == null) return;

    if (store.updateLocation) {
      address = AddressModel(
        id: address?.id,
        type: store.addressType ?? 'Residencial',
        zipCode: via.zipCode,
        street: via.street,
        number: store.number ?? 'S/N',
        complement: store.complement,
        neighborhood: via.neighborhood,
        state: via.state,
        city: via.city,
        geopoint: null,
        updatedAt: DateTime.now(),
      );
    }
    store.setZipStatus(ZipStatus.success);
  }

  @action
  Future<DataResult<ClientModel?>> saveClient() async {
    store.setState(PageState.loading);
    if (!store.isValid()) {
      store.setError('Preencha os campos obrigatórios (*) do formulário.');
      return DataResult.failure(const GenericFailure(
        message: 'Form fields are invalid.',
        code: 350,
      ));
    }
    final newClient = await getClientFromForm();
    if (newClient == null) {
      store.setError('Ocorreu um erro ineperado. Tente mais tarde.');
      return DataResult.failure(const GenericFailure(
        message: 'Unexpected error: Client return null.',
        code: 350,
      ));
    }
    final result = await repository.add(newClient);
    if (result.isFailure) {
      store.setError('Ocorreu um erro ineperado. Tente mais tarde.');
      return DataResult.failure(GenericFailure(
        message: 'Unexpected error: ${result.error.toString()}',
        code: 351,
      ));
    }
    // Update client
    client = result.data!;
    store.setState(PageState.success);
    return result;
  }

  @action
  Future<DataResult<ClientModel?>> updateClient() async {
    store.setState(PageState.loading);
    if (!store.isValid()) {
      store.setError('Preencha os campos obrigatórios (*) do formulário.');
      return DataResult.failure(const GenericFailure(
        message: 'Form fields are invalid.',
        code: 350,
      ));
    }
    final newClient = await getClientFromForm();
    if (newClient == null) {
      store.setError('Ocorreu um erro ineperado. Tente mais tarde.');
      return DataResult.failure(const GenericFailure(
        message: 'Unexpected error: Client return null.',
        code: 350,
      ));
    }
    final result = await repository.update(newClient);

    if (result.isFailure) {
      store.setError('Ocorreu um erro ineperado. Tente mais tarde.');
      return DataResult.failure(GenericFailure(
        message: 'Unexpected error: ${result.error.toString()}',
        code: 351,
      ));
    }
    // Update client
    client = result.data!;
    store.setState(PageState.success);
    return result;
  }
}
