import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/models/client.dart';
import '../../common/theme/app_text_style.dart';
import '../../common/utils/data_result.dart';
import '../../components/widgets/address_card.dart';
import '../../components/widgets/big_bottom.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/message_snack_bar.dart';
import '../../components/widgets/state_loading.dart';
import '../../stores/pages/add_client_store.dart';
import '../../stores/pages/common/store_func.dart';
import 'add_client_controller.dart';

class AddClientPage extends StatefulWidget {
  final ClientModel? client;

  const AddClientPage(
    this.client, {
    super.key,
  });

  static const routeName = '/addclient';

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final ctrl = AddClientController();
  final store = AddClientStore();
  late final bool isAddMode;

  @override
  void initState() {
    super.initState();
    isAddMode = (widget.client == null);
    ctrl.init(store, widget.client);
  }

  void _backPage() {
    Navigator.of(context).pop();
  }

  Future<void> _saveClient() async {
    if (!store.isValid()) return;
    if (store.isEdited) {
      DataResult<ClientModel?> result;
      if (isAddMode) {
        result = await ctrl.saveClient();
      } else {
        result = await ctrl.updateClient();
      }

      if (result.isFailure) {
        String msg = '';
        switch (result.error?.code ?? 300) {
          case 300:
            msg = result.error?.message ?? 'Erro desconhecido';
            break;
          case 350:
            msg =
                'Preencha os campos obrigatórios (*) do formulário para adicionar o cliente.';
            break;
          default:
            msg = result.error?.message ?? 'Erro desconhecido';
        }

        if (mounted) {
          showMessageSnackBar(
            context,
            title: 'Erro',
            msg: msg,
          );
        }
        return;
      }
    }
    _backPage();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAddMode ? 'Adicionar Cliente' : 'Editar Cliente'),
        centerTitle: true,
        elevation: 5,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Observer(
            builder: (context) => Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      labelText: 'Nome *',
                      controller: ctrl.nameController,
                      textInputAction: TextInputAction.next,
                      onChanged: store.setName,
                      errorText: store.errorName,
                      textCapitalization: TextCapitalization.words,
                    ),
                    CustomTextField(
                      labelText: 'Email',
                      controller: ctrl.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: store.setEmail,
                      errorText: store.errorEmail,
                    ),
                    CustomTextField(
                      labelText: 'Telefone *',
                      controller: ctrl.phoneController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onChanged: store.setPhone,
                      errorText: store.errorPhone,
                    ),
                    Row(
                      children: [
                        const Expanded(child: SizedBox(child: Divider())),
                        Text(
                          '  Endereço  ',
                          style: AppTextStyle.font16Bold(
                            color: colorScheme.primary,
                          ),
                        ),
                        const Expanded(child: SizedBox(child: Divider())),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Tipo de Endereço',
                        style: AppTextStyle.font12Height(height: .1),
                      ),
                    ),
                    DropdownButton<String>(
                      items: addressTypes
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      value: store.addressType,
                      isExpanded: true,
                      onChanged: (value) {
                        store.setAddressType(value ?? '');
                      },
                    ),
                    CustomTextField(
                      onChanged: (value) => store.setZipCode(value),
                      controller: ctrl.cepController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      labelText: 'CEP *',
                      hintText: 'xx-xxx.xxx',
                      errorText: store.errorZipCode,
                    ),
                    AddressCard(
                      zipStatus: store.zipStatus,
                      address: ctrl.address,
                    ),
                    CustomTextField(
                      controller: ctrl.numberController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Número *',
                      onChanged: store.setNumber,
                      errorText: store.errorNumber,
                      // hintText: '',
                    ),
                    CustomTextField(
                      controller: ctrl.complementController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                      textCapitalization: TextCapitalization.words,
                      labelText: 'Complemento',
                      onChanged: store.setComplement,
                      hintText: '- * -',
                    ),
                    // CustomTextField(
                    //   controller: ctrl.cpfController,
                    //   keyboardType: TextInputType.number,
                    //   textInputAction: TextInputAction.done,
                    //   floatingLabelBehavior: FloatingLabelBehavior.always,
                    //   labelText: 'CPF *',
                    //   hintText: '###.###.###-##',
                    //   onChanged: store.setCpf,
                    //   errorText: store.errorCpfMsg,
                    // ),
                    BigButton(
                      color: Colors.purpleAccent,
                      label: store.isEdited
                          ? isAddMode
                              ? 'Salvar'
                              : 'Atualizar'
                          : 'Cancelar',
                      onPressed: _saveClient,
                    ),
                  ],
                ),
                if (store.state == PageState.loading) const StateLoading(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
