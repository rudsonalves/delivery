// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_data_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PersonalDataStore on _PersonalDataStore, Store {
  late final _$phoneAtom =
      Atom(name: '_PersonalDataStore.phone', context: context);

  @override
  String? get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String? value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  late final _$errorPhoneMsgAtom =
      Atom(name: '_PersonalDataStore.errorPhoneMsg', context: context);

  @override
  String? get errorPhoneMsg {
    _$errorPhoneMsgAtom.reportRead();
    return super.errorPhoneMsg;
  }

  @override
  set errorPhoneMsg(String? value) {
    _$errorPhoneMsgAtom.reportWrite(value, super.errorPhoneMsg, () {
      super.errorPhoneMsg = value;
    });
  }

  late final _$zipCodeAtom =
      Atom(name: '_PersonalDataStore.zipCode', context: context);

  @override
  String? get zipCode {
    _$zipCodeAtom.reportRead();
    return super.zipCode;
  }

  @override
  set zipCode(String? value) {
    _$zipCodeAtom.reportWrite(value, super.zipCode, () {
      super.zipCode = value;
    });
  }

  late final _$errorZipCodeMsgAtom =
      Atom(name: '_PersonalDataStore.errorZipCodeMsg', context: context);

  @override
  String? get errorZipCodeMsg {
    _$errorZipCodeMsgAtom.reportRead();
    return super.errorZipCodeMsg;
  }

  @override
  set errorZipCodeMsg(String? value) {
    _$errorZipCodeMsgAtom.reportWrite(value, super.errorZipCodeMsg, () {
      super.errorZipCodeMsg = value;
    });
  }

  late final _$addressAtom =
      Atom(name: '_PersonalDataStore.address', context: context);

  @override
  AddressModel? get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(AddressModel? value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$numberAtom =
      Atom(name: '_PersonalDataStore.number', context: context);

  @override
  String? get number {
    _$numberAtom.reportRead();
    return super.number;
  }

  @override
  set number(String? value) {
    _$numberAtom.reportWrite(value, super.number, () {
      super.number = value;
    });
  }

  late final _$errorNumberMsgAtom =
      Atom(name: '_PersonalDataStore.errorNumberMsg', context: context);

  @override
  String? get errorNumberMsg {
    _$errorNumberMsgAtom.reportRead();
    return super.errorNumberMsg;
  }

  @override
  set errorNumberMsg(String? value) {
    _$errorNumberMsgAtom.reportWrite(value, super.errorNumberMsg, () {
      super.errorNumberMsg = value;
    });
  }

  late final _$stateAtom =
      Atom(name: '_PersonalDataStore.state', context: context);

  @override
  PageState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(PageState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$cpfAtom = Atom(name: '_PersonalDataStore.cpf', context: context);

  @override
  String? get cpf {
    _$cpfAtom.reportRead();
    return super.cpf;
  }

  @override
  set cpf(String? value) {
    _$cpfAtom.reportWrite(value, super.cpf, () {
      super.cpf = value;
    });
  }

  late final _$errorCpfMsgAtom =
      Atom(name: '_PersonalDataStore.errorCpfMsg', context: context);

  @override
  String? get errorCpfMsg {
    _$errorCpfMsgAtom.reportRead();
    return super.errorCpfMsg;
  }

  @override
  set errorCpfMsg(String? value) {
    _$errorCpfMsgAtom.reportWrite(value, super.errorCpfMsg, () {
      super.errorCpfMsg = value;
    });
  }

  late final _$_fetchAddressAsyncAction =
      AsyncAction('_PersonalDataStore._fetchAddress', context: context);

  @override
  Future<void> _fetchAddress() {
    return _$_fetchAddressAsyncAction.run(() => super._fetchAddress());
  }

  late final _$_PersonalDataStoreActionController =
      ActionController(name: '_PersonalDataStore', context: context);

  @override
  void setNumber(String value) {
    final _$actionInfo = _$_PersonalDataStoreActionController.startAction(
        name: '_PersonalDataStore.setNumber');
    try {
      return super.setNumber(value);
    } finally {
      _$_PersonalDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _validNumber() {
    final _$actionInfo = _$_PersonalDataStoreActionController.startAction(
        name: '_PersonalDataStore._validNumber');
    try {
      return super._validNumber();
    } finally {
      _$_PersonalDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhone(String value) {
    final _$actionInfo = _$_PersonalDataStoreActionController.startAction(
        name: '_PersonalDataStore.setPhone');
    try {
      return super.setPhone(value);
    } finally {
      _$_PersonalDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _validPhone() {
    final _$actionInfo = _$_PersonalDataStoreActionController.startAction(
        name: '_PersonalDataStore._validPhone');
    try {
      return super._validPhone();
    } finally {
      _$_PersonalDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setZipCode(String value) {
    final _$actionInfo = _$_PersonalDataStoreActionController.startAction(
        name: '_PersonalDataStore.setZipCode');
    try {
      return super.setZipCode(value);
    } finally {
      _$_PersonalDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _validZipCode() {
    final _$actionInfo = _$_PersonalDataStoreActionController.startAction(
        name: '_PersonalDataStore._validZipCode');
    try {
      return super._validZipCode();
    } finally {
      _$_PersonalDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCpf(String value) {
    final _$actionInfo = _$_PersonalDataStoreActionController.startAction(
        name: '_PersonalDataStore.setCpf');
    try {
      return super.setCpf(value);
    } finally {
      _$_PersonalDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _validCpf() {
    final _$actionInfo = _$_PersonalDataStoreActionController.startAction(
        name: '_PersonalDataStore._validCpf');
    try {
      return super._validCpf();
    } finally {
      _$_PersonalDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleFetchError(String message) {
    final _$actionInfo = _$_PersonalDataStoreActionController.startAction(
        name: '_PersonalDataStore._handleFetchError');
    try {
      return super._handleFetchError(message);
    } finally {
      _$_PersonalDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cleanFields() {
    final _$actionInfo = _$_PersonalDataStoreActionController.startAction(
        name: '_PersonalDataStore.cleanFields');
    try {
      return super.cleanFields();
    } finally {
      _$_PersonalDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
phone: ${phone},
errorPhoneMsg: ${errorPhoneMsg},
zipCode: ${zipCode},
errorZipCodeMsg: ${errorZipCodeMsg},
address: ${address},
number: ${number},
errorNumberMsg: ${errorNumberMsg},
state: ${state},
cpf: ${cpf},
errorCpfMsg: ${errorCpfMsg}
    ''';
  }
}
