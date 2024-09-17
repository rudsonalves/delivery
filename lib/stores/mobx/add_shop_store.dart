import 'package:mobx/mobx.dart';

import '../../common/models/address.dart';
import '../../repository/firebase_store/shop_firebase_repository.dart';
import '../../repository/viacep/via_cep_repository.dart';
import 'common/generic_functions.dart';

part 'add_shop_store.g.dart';

// ignore: library_private_types_in_public_api
class AddShopStore = _AddShopStore with _$AddShopStore;
final repository = ShopFirebaseRepository();

abstract class _AddShopStore with Store {
  @observable
  String? name;

  @observable
  String? errorName;

  @observable
  String? description;

  @observable
  String? addressType = 'Residencial';

  @observable
  String? zipCode;

  @observable
  String? errorZipCode;

  @observable
  AddressModel? address;

  @observable
  String? number;

  @observable
  String? errorNumber;

  @observable
  ZipStatus zipStatus = ZipStatus.initial;

  @observable
  PageState state = PageState.initial;

  @observable
  String? complement;

  @observable
  bool isEdited = false;

  @action
  void setName(String value) {
    name = value;
    _validName();
  }

  @action
  void _validName() {
    errorName =
        name!.trim().length < 3 ? 'Nome dever ter 3 ou mais caracteres' : null;
  }

  @action
  void setDescription(String value) {
    description = value;
  }

  @action
  void setComplement(String value) {
    _checkIsEdited(complement, value);
    complement = value;
    _updateAddress();
  }

  @action
  _checkIsEdited(String? value, String? newValue) {
    isEdited = value != newValue;
  }

  @action
  void setAddressType(String value) {
    _checkIsEdited(addressType, value);
    addressType = value;
    _updateAddress();
  }

  @action
  void setNumber(String value) {
    _checkIsEdited(addressType, value);
    number = value;
    _validName();
  }

  @action
  void _validNumber() {
    if (number == null || number!.isEmpty) {
      errorNumber = 'Número é obrigatório';
      return;
    }
    errorNumber = null;
  }

  @action
  void setZipCode(String value) {
    _checkIsEdited(zipCode, value);
    zipCode = value;
    _validZipCode();
    if (errorZipCode == null) _fetchAddress();
  }

  @action
  void _validZipCode() {
    final numbers = _removeNonNumber(zipCode ?? '');

    if (numbers.length == 8) {
      errorZipCode = null;
    } else {
      errorZipCode = 'CEP inválido';
    }
  }

  @action
  Future<void> _fetchAddress() async {
    try {
      zipStatus = ZipStatus.loading;

      final response = await ViaCepRepository.getLocalByCEP(zipCode!);
      if (!response.isSuccess) {
        _handleFetchError('Erro ao buscar o endereço: ${response.error}');
        errorZipCode = 'CEP inválido';
        return;
      }

      final viaAddress = response.data;
      if (viaAddress == null) {
        _handleFetchError('Endereço não encontrado');
        errorZipCode = 'CEP inválido';
        return;
      }

      address = AddressModel(
        zipCode: viaAddress.zipCode,
        street: viaAddress.street,
        number: number ?? 'S/N',
        complement: complement ?? '',
        type: addressType ?? 'Residencial',
        neighborhood: viaAddress.neighborhood,
        latitude: null,
        longitude: null,
        state: viaAddress.state,
        city: viaAddress.city,
      );

      zipStatus = ZipStatus.success;
      errorZipCode = null;
      return;
    } catch (err) {
      _handleFetchError('erro desconhecido: $err');
      return;
    }
  }

  @action
  _updateAddress() {
    if (address != null) {
      address = address!.copyWith(
        number: number ?? 'S/N',
        complement: complement ?? '',
      );
    }
  }

  @action
  void _handleFetchError(String message) {
    // errorMsg = message;
    zipStatus = ZipStatus.error;
    // log(errorMsg!);
  }

  @action
  void setPageState(PageState newState) {
    state = newState;
  }

  String _removeNonNumber(String? value) {
    return value?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
  }
}
