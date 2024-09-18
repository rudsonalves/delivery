import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../stores/mobx/common/store_func.dart';
import '/components/widgets/big_bottom.dart';
import '../../components/widgets/custom_text_field.dart';
import 'person_data_controller.dart';

class PersonDataPage extends StatefulWidget {
  const PersonDataPage({
    super.key,
  });

  static const routeName = '/delivery_person';

  @override
  State<PersonDataPage> createState() => _PersonDataPageState();
}

class _PersonDataPageState extends State<PersonDataPage> {
  final ctrl = PersonController();

  void _backPage() {
    if (ctrl.isValid) {
      ctrl.save(context);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete seu Cadastro'),
        centerTitle: true,
        elevation: 5,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Form(
            key: ctrl.formKey,
            child: Column(
              children: [
                Observer(
                  builder: (_) => CustomTextField(
                    controller: ctrl.phoneController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Telefone *',
                    hintText: '(xx) xxxx-xxxxx',
                    onChanged: ctrl.personalData.setPhone,
                    errorText: ctrl.personalData.errorPhoneMsg,
                  ),
                ),
                Observer(
                  builder: (context) => CustomTextField(
                    onChanged: (value) => ctrl.personalData.setZipCode(value),
                    controller: ctrl.cepController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'CEP *',
                    hintText: 'xx-xxx.xxx',
                    errorText: ctrl.personalData.errorZipCodeMsg,
                  ),
                ),
                Observer(
                  builder: (context) {
                    if (ctrl.personalData.state == PageState.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (ctrl.personalData.state == PageState.error) {
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
                    } else if (ctrl.personalData.state == PageState.success) {
                      final address = ctrl.personalData.address!;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: colorScheme.tertiaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(text: 'R/Av: '),
                                      TextSpan(text: address.street),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(text: 'Bairro: '),
                                      TextSpan(text: address.neighborhood),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(text: 'Cidade: '),
                                      TextSpan(text: address.city),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(text: 'Estado: '),
                                      TextSpan(text: address.state),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                    onChanged: ctrl.personalData.setNumber,
                    errorText: ctrl.personalData.errorNumberMsg,
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
                //     onChanged: ctrl.personalData.setCpf,
                //     errorText: ctrl.personalData.errorCpfMsg,
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
      ),
    );
  }
}
