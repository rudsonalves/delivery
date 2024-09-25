import 'package:mobx/mobx.dart';

import '../../common/models/address.dart';
import '../../common/models/client.dart';
import '../../common/models/via_cep_address.dart';
import '../../common/utils/data_result.dart';
import '../../repository/firebase_store/client_firebase_repository.dart';
import 'common/store_func.dart';
import '/common/extensions/generic_extensions.dart';

part 'add_client_store.g.dart';

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
  PageState state = PageState.initial;

  @observable
  String? cpf;

  @observable
  String? errorCpfMsg;

  @observable
  String? complement;

  @observable
  bool isEdited = false;

  @observable
  bool updateLocation = false;

  String? id;

  Future<ClientModel?> getClientFromForm() async {
    state = PageState.loading;
    if (!isValid()) {
      state = PageState.success;
      return null;
    }

    if (address == null) {
      await _mountAddress();
    }
    if (updateLocation) {
      address!.complement = complement;
      address!.number = number!;
      await _setCoordinates();
    }
    address!.type = addressType!;

    state = PageState.success;
    return ClientModel(
      id: id,
      name: name!,
      email: email,
      phone: phone!,
      address: address?.copyWith(),
      addressString: address?.geoAddressString,
      location: address?.location,
    );
  }

  @action
  void setClientFromClient(ClientModel client) {
    id = client.id;
    name = client.name;
    email = client.email;
    phone = client.phone;
    addressType = client.address?.type ?? 'Residencial';
    number = client.address?.number;
    zipCode = client.address?.zipCode;
    complement = client.address?.complement;
    address = client.address?.copyWith();
    zipStatus = address != null ? ZipStatus.success : ZipStatus.initial;
    isEdited = false;
    updateLocation = false;
  }

  @action
  void setComplement(String value) {
    _checkIsEdited(complement, value);
    complement = value;
  }

  @action
  _checkIsEdited(String? value, String newValue) {
    isEdited = _isChanged(value, newValue) || isEdited;
  }

  bool _isChanged(String? value, String newValue) {
    return newValue != value;
  }

  @action
  void setAddressType(String value) {
    _checkIsEdited(addressType, value);
    addressType = value;
  }

  @action
  void setName(String value) {
    _checkIsEdited(name, value);
    name = value;
    _validName();
  }

  void _validName() {
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
    _validEmail();
  }

  @action
  bool isEmailValid() {
    _validEmail();
    return errorEmail == null;
  }

  @action
  void _validEmail() {
    errorEmail = StoreFunc.itsNotEmail(email)
        ? 'Por favor, insira um email válido'
        : null;
  }

  @action
  void setPhone(String value) {
    _checkIsEdited(phone, value);
    phone = value;
    _validPhone();
  }

  @action
  void _validPhone() {
    final numebers = phone?.onlyNumbers() ?? '';
    if (numebers.length != 11) {
      errorPhone = 'Telephone inválido';
    } else {
      errorPhone = null;
    }
  }

  @action
  void setNumber(String value) {
    _checkIsEdited(addressType, value);
    updateLocation = updateLocation || (number != value);
    number = value;
    _validNumber();
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
    updateLocation = updateLocation || (zipCode != value);
    zipCode = value;
    _validZipCode();
    if (errorZipCode == null) _mountAddress();
  }

  @action
  void _validZipCode() {
    final numbers = zipCode?.onlyNumbers() ?? '';

    if (numbers.length == 8) {
      errorZipCode = null;
    } else {
      errorZipCode = 'CEP inválido';
    }
  }

  @action
  void setCpf(String value) {
    _checkIsEdited(cpf, value);
    cpf = value.onlyNumbers();
    _validCpf();
  }

  @action
  void _validCpf() {
    errorCpfMsg = StoreFunc.validCpf(cpf);
  }

  @action
  Future<void> _mountAddress() async {
    zipStatus = ZipStatus.loading;

    ZipStatus status;
    String? err;
    ViaCepAddressModel? via;
    (status, err, via) = await StoreFunc.fetchAddress(zipCode);

    zipStatus = status;
    errorZipCode = err;

    if (via == null) return;

    if (updateLocation) {
      address = AddressModel(
        zipCode: via.zipCode,
        street: via.street,
        number: number ?? 'S/N',
        complement: complement,
        type: addressType ?? 'Residencial',
        neighborhood: via.neighborhood,
        location: null,
        state: via.state,
        city: via.city,
      );
    }

    if (address!.isValidAddress) {
      await _setCoordinates();
    }
    zipStatus = ZipStatus.success;
  }

  @action
  Future<void> _setCoordinates() async {
    address = await address!.updateLocation();
    updateLocation = false;
  }

  @action
  void setPageState(PageState status) {
    state = status;
  }

  @action
  bool isValid() {
    _validEmail();
    _validNumber();
    _validZipCode();
    _validName();
    _validPhone();

    return errorEmail == null &&
        errorNumber == null &&
        errorZipCode == null &&
        errorName == null &&
        errorPhone == null;
  }

  @action
  Future<DataResult<ClientModel?>> saveClient() async {
    state = PageState.loading;
    if (!isValid()) {
      state = PageState.error;
      return DataResult.failure(const GenericFailure(
        message: 'Form fields are invalid.',
        code: 350,
      ));
    }
    final client = await getClientFromForm();
    if (client == null) {
      state = PageState.error;
      return DataResult.failure(const GenericFailure(
        message: 'Unexpected error: Client return null.',
        code: 350,
      ));
    }
    final result = await repository.add(client);
    state = result.isSuccess ? PageState.success : PageState.error;
    return result;
  }

  @action
  Future<DataResult<ClientModel?>> updateClient() async {
    state = PageState.loading;
    if (!isValid()) {
      state = PageState.error;
      return DataResult.failure(const GenericFailure(
        message: 'Form fields are invalid.',
        code: 350,
      ));
    }
    final client = await getClientFromForm();
    if (client == null) {
      state = PageState.error;
      return DataResult.failure(const GenericFailure(
        message: 'Unexpected error: Client return null.',
        code: 350,
      ));
    }
    // client.id = id;
    final result = await repository.update(client);
    state = result.isSuccess ? PageState.success : PageState.error;
    return result;
  }
}
