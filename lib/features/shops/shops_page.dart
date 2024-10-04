import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../components/widgets/dismissible_help_row.dart';
import '../../stores/common/store_func.dart';
import 'stores/shops_store.dart';
import '/features/add_shop/add_shop_page.dart';
import '../../common/models/shop.dart';
import '../../common/theme/app_text_style.dart';
import 'shops_controller.dart';
import 'widgets/dismissible_shop.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  static const routeName = '/stores';

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  final ctrl = ShopsController();
  final store = ShopsStore();

  @override
  void initState() {
    super.initState();

    ctrl.init(store);
  }

  @override
  void dispose() {
    ctrl.dispose();

    super.dispose();
  }

  void _backPage() {
    Navigator.of(context).pop();
  }

  void _addShop() {
    Navigator.pushNamed(
      context,
      AddShopPage.routeName,
    );
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
                onPressed: () => Navigator.pop(
                  context,
                  true,
                ),
                child: const Text('Apagar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(
                  context,
                  false,
                ),
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
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const DismissibleHelpRow(),
            Expanded(
              child: Observer(
                builder: (_) {
                  switch (store.state) {
                    case PageState.initial:
                    case PageState.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case PageState.success:
                      final shops = store.shops;
                      if (shops.isEmpty) {
                        return const Center(
                          child: Text('Nenhuma loja encontrada!'),
                        );
                      }

                      return ListView.builder(
                        itemCount: shops.length,
                        itemBuilder: (_, index) {
                          final shop = shops[index];

                          return DismissibleShop(
                            shop: shop,
                            editShop: _editShop,
                            deleteShop: _deleteShop,
                          );
                        },
                      );
                    case PageState.error:
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              store.errorMessage ?? 'Ocorreu um erro.',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.font16Bold(color: Colors.red),
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: () {
                                // ctrl.refresh(userId, store.radiusInKm);
                              },
                              label: const Text('Tentar Novamente.'),
                              icon: const Icon(Icons.refresh),
                            ),
                          ],
                        ),
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
