import 'package:mobx/mobx.dart';

import '../../common/models/address.dart';
import '../../common/models/client.dart';
import '../../common/utils/data_result.dart';
import '../../repository/firebase_store/client_firebase_repository.dart';
import '../../repository/viacep/via_cep_repository.dart';
import '../../services/geolocation_service.dart';
import 'common/generic_functions.dart';

part 'add_client_store.g.dart';

enum ZipStatus { initial, loading, success, error }

enum PageStatus { initial, loading, success, error }

// ignore: library_private_types_in_public_api
class AddClientStore = _AddClientStore with _$AddClientStore;
final repository = ClientFirebaseRepository();

abstract class _AddClientStore with Store {
  @observable
  String? name;

  @observable
  String? errorName;

  @observable
  String? email;

  @observable
  String? errorEmail;

  @observable
  String? phone;

  @observable
  String? errorPhone;

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
  PageStatus pageStatus = PageStatus.initial;

  @observable
  String? cpf;

  @observable
  String? errorCpfMsg;

  @observable
  String? complement;

  @observable
  bool isEdited = false;

  String? id;

  Future<ClientModel?> getClientFromForm() async {
    pageStatus = PageStatus.loading;
    if (address != null) {
      if (address!.latitude != null && address!.longitude != null) {
        pageStatus = PageStatus.success;
        return ClientModel(
          id: id,
          name: name!,
          email: email,
          phone: phone!,
          address: address!,
        );
      }
      final result =
          await GeolocationServiceGoogle.getCoordinatesFromAddress(address!);
      if (result.isFailure || result.data == null) {
        pageStatus = PageStatus.error;
        return null;
      }

      address = result.data;
      pageStatus = PageStatus.success;
      return ClientModel(
        name: name!,
        email: email,
        phone: phone!,
        address: address!,
      );
    }
    return null;
  }

  @action
  void setClientFromClient(ClientModel client) {
    id = client.id;
    setName(client.name);
    setEmail(client.email ?? '');
    setPhone(client.phone);
    setAddressType(client.address?.type ?? 'Residencial');
    setNumber(client.address?.number ?? 'S/N');
    // setZipCode(client.address?.zipCode ?? '');
    zipCode = client.address?.zipCode ?? '';
    setComplement(client.address?.complement ?? '');
    address = client.address?.copyWith();
    zipStatus = address != null ? ZipStatus.success : ZipStatus.initial;
    isEdited = false;
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
  void setName(String value) {
    _checkIsEdited(name, value);
    name = value;
    _validateName();
  }

  void _validateName() {
    if (name == null || name!.length < 3) {
      errorName = 'nome deve ser maior que 3 caracteres';
    } else {
      errorName = null;
    }
  }

  @action
  void setEmail(String value) {
    _checkIsEdited(email, value);
    email = value;
    _validateEmail();
  }

  @action
  bool isEmailValid() {
    _validateEmail();
    return errorEmail == null;
  }

  @action
  void _validateEmail() {
    errorEmail = StoreFunc.itsNotEmail(email)
        ? 'Por favor, insira um email válido'
        : null;
  }

  @action
  void setPhone(String value) {
    _checkIsEdited(phone, value);
    phone = value;
    _validatePhone();
  }

  @action
  void _validatePhone() {
    final numebers = _removeNonNumber(phone);
    if (numebers.length != 11) {
      errorPhone = 'Telephone inválido';
    } else {
      errorPhone = null;
    }
  }

  @action
  void setNumber(String value) {
    _checkIsEdited(number, value);
    number = value;
    _validNumber();
    _updateAddress();
    if (address != null) {
      address!.latitude = null;
      address!.longitude = null;
    }
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
  void setCpf(String value) {
    _checkIsEdited(cpf, value);
    cpf = _removeNonNumber(value);
    _validCpf();
  }

  @action
  void _validCpf() {
    if (cpf == null ||
        cpf!.length != 11 ||
        RegExp(r'^(\d)\1*$').hasMatch(cpf!)) {
      errorCpfMsg = 'CPF inválido';
      return;
    }

    int digit1 = _calculateDigit(cpf!.substring(0, 9), 10);
    int digit2 = _calculateDigit(cpf!.substring(0, 10), 11);

    bool valid = digit1 == int.parse(cpf![9]) && digit2 == int.parse(cpf![10]);
    if (!valid) {
      errorCpfMsg = 'CPF inválido';
      return;
    }
    errorCpfMsg = null;
  }

  int _calculateDigit(String cpf, int factor) {
    int total = 0;
    for (int i = 0; i < cpf.length; i++) {
      total += int.parse(cpf[i]) * factor--;
    }
    int rest = total % 11;
    return (rest < 2) ? 0 : 11 - rest;
  }

  String _removeNonNumber(String? value) {
    return value?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
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
  void setPageStatus(PageStatus status) {
    pageStatus = status;
  }

  @action
  bool isValid() {
    // _validCpf();
    _validNumber();
    _validZipCode();
    _validateName();
    _validatePhone();

    return errorNumber == null &&
        errorZipCode == null &&
        errorName == null &&
        errorPhone == null;
  }

  @action
  Future<DataResult<ClientModel?>> saveClient() async {
    pageStatus = PageStatus.loading;
    if (!isValid()) {
      pageStatus = PageStatus.error;
      return DataResult.failure(const GenericFailure(
        message: 'Form fields are invalid.',
        code: 350,
      ));
    }
    final client = await getClientFromForm();
    if (client == null) {
      pageStatus = PageStatus.error;
      return DataResult.failure(const GenericFailure(
        message: 'Unexpected error: Client return null.',
        code: 350,
      ));
    }
    final result = await repository.add(client);
    pageStatus = result.isSuccess ? PageStatus.success : PageStatus.error;
    return result;
  }

  @action
  Future<DataResult<ClientModel?>> updateClient() async {
    pageStatus = PageStatus.loading;
    if (!isValid()) {
      pageStatus = PageStatus.error;
      return DataResult.failure(const GenericFailure(
        message: 'Form fields are invalid.',
        code: 350,
      ));
    }
    final client = await getClientFromForm();
    if (client == null) {
      pageStatus = PageStatus.error;
      return DataResult.failure(const GenericFailure(
        message: 'Unexpected error: Client return null.',
        code: 350,
      ));
    }
    // client.id = id;
    final result = await repository.update(client);
    pageStatus = result.isSuccess ? PageStatus.success : PageStatus.error;
    return result;
  }
}
