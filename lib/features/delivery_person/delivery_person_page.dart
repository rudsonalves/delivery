import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../components/widgets/custom_text_field.dart';
import '../../stores/mobx/delivery_person_store.dart';
import 'delivery_person_controller.dart';

class DeliveryPersonPage extends StatefulWidget {
  const DeliveryPersonPage({
    super.key,
  });

  static const routeName = '/delivery_person';

  @override
  State<DeliveryPersonPage> createState() => _DeliveryPersonPageState();
}

class _DeliveryPersonPageState extends State<DeliveryPersonPage> {
  final ctrl = DeliveryPersonController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Entregador'),
        centerTitle: true,
        elevation: 5,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
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
                    controller: ctrl.nameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Nome *',
                    hintText: 'Nome Completo',
                    onChanged: ctrl.deliveryPerson.setName,
                    errorText: ctrl.deliveryPerson.errorNameMsg,
                  ),
                ),
                Observer(
                  builder: (_) => CustomTextField(
                    controller: ctrl.phoneController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Telefone *',
                    hintText: '(xx) xxxx-xxxxx',
                    onChanged: ctrl.deliveryPerson.setPhone,
                    errorText: ctrl.deliveryPerson.errorPhoneMsg,
                  ),
                ),
                Observer(
                  builder: (context) => CustomTextField(
                    onChanged: (value) => ctrl.deliveryPerson.setZipCode(value),
                    controller: ctrl.cepController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'CEP *',
                    hintText: 'xx-xxx.xxx',
                    errorText: ctrl.deliveryPerson.errorZipCodeMsg,
                  ),
                ),
                Observer(
                  builder: (context) {
                    if (ctrl.deliveryPerson.status == Status.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (ctrl.deliveryPerson.status == Status.error) {
                      return SnackBar(
                        elevation: 5,
                        content: Text(
                          'Erro desconhecido.',
                          style: TextStyle(color: colorScheme.error),
                        ),
                      );
                    } else if (ctrl.deliveryPerson.status == Status.success) {
                      final address = ctrl.deliveryPerson.address!;
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
                    onChanged: ctrl.deliveryPerson.setNumber,
                    errorText: ctrl.deliveryPerson.errorNumberMsg,
                    // hintText: '',
                  ),
                ),
                CustomTextField(
                  controller: ctrl.complementController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Complemento',
                  hintText: '- * -',
                ),
                Observer(
                  builder: (_) => CustomTextField(
                    controller: ctrl.cpfController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'CPF *',
                    hintText: '###.###.###-##',
                    onChanged: ctrl.deliveryPerson.setCpf,
                    errorText: ctrl.deliveryPerson.errorCpfMsg,
                  ),
                ),
                Observer(
                  builder: (_) => CustomTextField(
                    controller: ctrl.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'E-mail *',
                    hintText: 'seu@email.com.br',
                    onChanged: ctrl.deliveryPerson.setEmail,
                    errorText: ctrl.deliveryPerson.errorEmailMsg,
                  ),
                ),
                Observer(
                  builder: (_) => CustomTextField(
                    controller: ctrl.passWordController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Senha *',
                    hintText: '6+ letras e números',
                    obscureText: true,
                    onChanged: ctrl.deliveryPerson.setPassword,
                    errorText: ctrl.deliveryPerson.errorPasswordMsg,
                  ),
                ),
                Observer(
                  builder: (_) => CustomTextField(
                    controller: ctrl.passWordCheckController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Confirme a Senha *',
                    hintText: '6+ letras e números',
                    obscureText: true,
                    onChanged: ctrl.deliveryPerson.setCheckPassword,
                    errorText: ctrl.deliveryPerson.errorCheckPasswordMsg,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OverflowBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () {},
                        label: const Text('Adicionar'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () {},
                        label: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
