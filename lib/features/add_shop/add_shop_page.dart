import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/features/add_shop/add_shop_controller.dart';
import '../../common/theme/app_text_style.dart';
import '../../components/widgets/big_bottom.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../stores/mobx/common/generic_functions.dart';

class AddShopPage extends StatefulWidget {
  const AddShopPage({super.key});

  static const routeName = '/add_store';

  @override
  State<AddShopPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  final ctrl = AddShopController();

  void _backPage() {
    Navigator.of(context).pop();
  }

  void _saveClient() {}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Loja'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                labelText: 'Nome *',
                controller: ctrl.nameController,
                textInputAction: TextInputAction.next,
                onChanged: ctrl.pageStore.setName,
                errorText: ctrl.pageStore.errorName,
                textCapitalization: TextCapitalization.sentences,
              ),
              CustomTextField(
                labelText: 'Descrição',
                controller: ctrl.descriptionController,
                textInputAction: TextInputAction.next,
                onChanged: ctrl.pageStore.setDescription,
                textCapitalization: TextCapitalization.words,
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
                value: ctrl.pageStore.addressType,
                isExpanded: true,
                onChanged: (value) {
                  ctrl.pageStore.setAddressType(value ?? '');
                },
              ),
              CustomTextField(
                onChanged: (value) => ctrl.pageStore.setZipCode(value),
                controller: ctrl.cepController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                labelText: 'CEP *',
                hintText: 'xx-xxx.xxx',
                errorText: ctrl.pageStore.errorZipCode,
              ),
              Observer(
                builder: (context) {
                  if (ctrl.pageStore.zipStatus == ZipStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (ctrl.pageStore.zipStatus == ZipStatus.error) {
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
                  } else if (ctrl.pageStore.zipStatus == ZipStatus.success) {
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
              CustomTextField(
                controller: ctrl.numberController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                // floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Número *',
                onChanged: ctrl.pageStore.setNumber,
                errorText: ctrl.pageStore.errorNumber,
                // hintText: '',
              ),
              CustomTextField(
                controller: ctrl.complementController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                // floatingLabelBehavior: FloatingLabelBehavior.always,
                textCapitalization: TextCapitalization.words,
                labelText: 'Complemento',
                onChanged: ctrl.pageStore.setComplement,
                hintText: '- * -',
              ),
              BigButton(
                color: Colors.purpleAccent,
                label: ctrl.isEdited
                    ? ctrl.isAddMode
                        ? 'Salvar'
                        : 'Atualizar'
                    : 'Cancelar',
                onPressed: _saveClient,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
