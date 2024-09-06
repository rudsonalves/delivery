import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/common/theme/app_text_style.dart';
import '/features/add_client/add_client_controller.dart';
import '../../components/widgets/big_bottom.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../stores/mobx/add_client_store.dart';

class AddCliendPage extends StatefulWidget {
  const AddCliendPage({super.key});

  static const routeName = '/addclient';

  @override
  State<AddCliendPage> createState() => _AddCliendPageState();
}

const addressTypes = [
  'Apartamento',
  'Clínica',
  'Escritório',
  'Residencial',
  'Trabalho',
];

class _AddCliendPageState extends State<AddCliendPage> {
  final ctrl = AddClientController();

  void _backPage() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cliente'),
        centerTitle: true,
        elevation: 5,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Observer(
                builder: (_) => CustomTextField(
                  labelText: 'Nome *',
                  controller: ctrl.nameController,
                  textInputAction: TextInputAction.next,
                  onChanged: ctrl.pageStore.setName,
                  errorText: ctrl.pageStore.errorName,
                ),
              ),
              Observer(
                builder: (_) => CustomTextField(
                  labelText: 'Email',
                  controller: ctrl.emailController,
                  textInputAction: TextInputAction.next,
                  onChanged: ctrl.pageStore.setEmail,
                  errorText: ctrl.pageStore.errorEmail,
                ),
              ),
              Observer(
                builder: (_) => CustomTextField(
                  labelText: 'Telefone *',
                  controller: ctrl.phoneController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onChanged: ctrl.pageStore.setPhone,
                  errorText: ctrl.pageStore.errorPhone,
                ),
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
              Observer(
                builder: (context) => DropdownButton<String>(
                  items: addressTypes
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  value: ctrl.pageStore.addressType,
                  isExpanded: true,
                  onChanged: (value) {
                    ctrl.pageStore.setAddressType(value ?? '');
                  },
                ),
              ),
              Observer(
                builder: (context) => CustomTextField(
                  onChanged: (value) => ctrl.pageStore.setZipCode(value),
                  controller: ctrl.cepController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'CEP *',
                  hintText: 'xx-xxx.xxx',
                  errorText: ctrl.pageStore.errorZipCodeMsg,
                ),
              ),
              Observer(
                builder: (context) {
                  if (ctrl.pageStore.status == Status.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (ctrl.pageStore.status == Status.error) {
                    return Card(
                      color: colorScheme.tertiaryContainer,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 64,
                          vertical: 12,
                        ),
                        child: Text('Endereço inválido'),
                      ),
                    );
                  } else if (ctrl.pageStore.status == Status.success) {
                    final address = ctrl.pageStore.address;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: colorScheme.tertiaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text((address != null)
                              ? address.addressString()
                              : '- * -'),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              Observer(
                builder: (_) => CustomTextField(
                  controller: ctrl.numberController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Número *',
                  onChanged: ctrl.pageStore.setNumber,
                  errorText: ctrl.pageStore.errorNumberMsg,
                  // hintText: '',
                ),
              ),
              CustomTextField(
                controller: ctrl.complementController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                textCapitalization: TextCapitalization.words,
                labelText: 'Complemento',
                onChanged: ctrl.pageStore.setComplement,
                hintText: '- * -',
              ),
              // Observer(
              //   builder: (_) => CustomTextField(
              //     controller: ctrl.cpfController,
              //     keyboardType: TextInputType.number,
              //     textInputAction: TextInputAction.done,
              //     floatingLabelBehavior: FloatingLabelBehavior.always,
              //     labelText: 'CPF *',
              //     hintText: '###.###.###-##',
              //     onChanged: ctrl.pageStore.setCpf,
              //     errorText: ctrl.pageStore.errorCpfMsg,
              //   ),
              // ),
              BigButton(
                color: Colors.purpleAccent,
                label: 'Salvar',
                onPressed: _backPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
