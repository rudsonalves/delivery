import 'package:delivery/features/add_shop/add_shop_page.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../common/models/shop.dart';
import '../../common/theme/app_text_style.dart';
import '../../components/widgets/base_dismissible_container.dart';
import '../../components/widgets/state_loading.dart';
import 'shops_controller.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  static const routeName = '/stores';

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  final ctrl = ShopsController();

  void _backPage() {
    Navigator.of(context).pop();
  }

  void _addShop() {
    Navigator.pushNamed(context, AddShopPage.routeName);
  }

  Future<void> _editShop(ShopModel shop) async {
    await ctrl.editShop(context, shop);
  }

  Future<bool> _deleteShop(ShopModel shop) async {
    final result = await showDialog<bool?>(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(
              Icons.warning_amber_rounded,
              size: 60,
            ),
            title: const Text('Apagar Cliente'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: 'Todos os dados da loja'),
                      TextSpan(
                        text: '\n\n"${shop.name}"\n\n',
                        style: AppTextStyle.font12Bold(),
                      ),
                      const TextSpan(
                          text: 'serão removidos.\n\nConfirme a ação.'),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              FilledButton.tonal(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Apagar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ) ??
        false;

    if (result) {
      final response = await ctrl.deleteClient(shop);
      if (response.isFailure) {
        return false;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Lojas'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _backPage,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addShop,
        child: const Icon(Symbols.add_business),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<ShopModel>>(
          stream: ctrl.shopRepository.streamShopByName(),
          builder: (context, snapshot) {
            List<ShopModel> shops = snapshot.data ?? [];

            return Stack(
              children: [
                if (shops.isNotEmpty)
                  ListView.builder(
                    itemCount: shops.length,
                    itemBuilder: (context, index) => Dismissible(
                      key: UniqueKey(),
                      background: baseDismissibleContainer(
                        context,
                        alignment: Alignment.centerLeft,
                        color: Colors.green.withOpacity(.30),
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                      secondaryBackground: baseDismissibleContainer(
                        context,
                        alignment: Alignment.centerRight,
                        color: Colors.red.withOpacity(.30),
                        icon: Icons.delete,
                        label: 'Apagar',
                        // enable: ctrl.isAdmin,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Card(
                          margin: EdgeInsets.zero,
                          color: colorScheme.surfaceContainerHigh,
                          child: ListTile(
                            title: Text(shops[index].name),
                            subtitle: Text(shops[index].description ?? ''),
                          ),
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          _editShop(shops[index]);
                        } else if (direction == DismissDirection.endToStart) {
                          return await _deleteShop(shops[index]);
                        }
                        return false;
                      },
                    ),
                  ),
                if (shops.isEmpty)
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: 60,
                                ),
                                Text('Nenhum cliente encontrado.')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const StateLoading(),
              ],
            );
          },
        ),
      ),
    );
  }
}
