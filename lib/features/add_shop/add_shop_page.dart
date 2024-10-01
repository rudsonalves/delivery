import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../common/models/shop.dart';
import '../../common/utils/data_result.dart';
import '../../components/widgets/address_card.dart';
import '../../components/widgets/message_snack_bar.dart';
import '../../components/widgets/state_loading.dart';
import '../../stores/pages/add_shop_store.dart';
import '../qrcode_read/qrcode_read_page.dart';
import '/features/add_shop/add_shop_controller.dart';
import '../../common/theme/app_text_style.dart';
import '../../components/widgets/big_bottom.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../stores/pages/common/store_func.dart';

class AddShopPage extends StatefulWidget {
  final ShopModel? shop;

  const AddShopPage(
    this.shop, {
    super.key,
  });

  static const routeName = '/add_shop';

  @override
  State<AddShopPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  final store = AddShopStore();
  final ctrl = AddShopController();

  @override
  void initState() {
    super.initState();

    ctrl.init(store, widget.shop);
  }

  void _backPage() {
    Navigator.of(context).pop();
  }

  Future<void> _saveShop() async {
    if (!ctrl.isValid) return;
    if (ctrl.isEdited) {
      DataResult<ShopModel?> result;
      if (ctrl.isAddMode) {
        result = await ctrl.saveShop();
      } else {
        result = await ctrl.updateShop();
      }

      if (result.isFailure) {
        String msg = '';
        switch (result.error?.code ?? 500) {
          case 500:
            msg = result.error?.message ?? 'Erro desconhecido';
            break;
          case 550:
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
    if (mounted) Navigator.of(context).pop(ctrl.shop!.copyWith());
  }

  Future<void> _getManager() async {
    final manager = await Navigator.pushNamed(context, QRCodeReadPage.routeName)
        as Map<String, dynamic>?;

    if (manager != null) ctrl.setManager(manager);
  }

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
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    CustomTextField(
                      labelText: 'Descrição',
                      controller: ctrl.descriptionController,
                      textInputAction: TextInputAction.next,
                      onChanged: store.setDescription,
                      textCapitalization: TextCapitalization.words,
                    ),
                    CustomTextField(
                      labelText: 'Telefone *',
                      controller: ctrl.phoneController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onChanged: store.setPhone,
                      errorText: store.errorPhone,
                    ),
                    InkWell(
                      onTap: _getManager,
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Symbols.manage_accounts_rounded),
                          title: Text(store.managerName ?? '- * -'),
                        ),
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
                        if (value != null) {
                          store.setAddressType(value);
                        }
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
                    BigButton(
                      color: Colors.purpleAccent,
                      label: ctrl.isEdited
                          ? ctrl.isAddMode
                              ? 'Salvar'
                              : 'Atualizar'
                          : 'Cancelar',
                      onPressed: _saveShop,
                    ),
                  ],
                ),
                if (ctrl.state == PageState.loading) const StateLoading(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
