import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../components/widgets/custom_app_bar/custom_app_bar.dart';
import '../../components/widgets/main_drawer/custom_drawer.dart';
import '/components/widgets/shop_card.dart';
import '/common/theme/app_text_style.dart';
import '/locator.dart';
import '../../stores/common/store_func.dart';
import 'stores/user_delivery_store.dart';
import '../../stores/user/user_store.dart';
import 'user_delivery_controller.dart';

class UserDeliveryPage extends StatefulWidget {
  final PageController pageController;
  const UserDeliveryPage(
    this.pageController, {
    super.key,
  });

  @override
  State<UserDeliveryPage> createState() => _UserDeliveryPageState();
}

class _UserDeliveryPageState extends State<UserDeliveryPage> {
  final store = UserDeliveryStore();
  final ctrl = UserDeliveryController();
  final _currentUser = locator<UserStore>().currentUser;

  late final String userId;

  // Map to track the expanded state of each shop
  final Map<int, bool> _expandedState = {};

  @override
  void initState() {
    super.initState();

    if (_currentUser == null || _currentUser.id == null) {
      store.setError('Usuário não autenticado.');
      return;
    }
    userId = _currentUser.id!;

    ctrl.init(store: store);
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Entregador'),
        elevation: 5,
      ),
      drawer: CustomDrawer(widget.pageController),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Observer(
                  builder: (_) =>
                      Text('Raio: ${store.radiusInKm.toStringAsFixed(1)} km'),
                ),
                Expanded(
                  child: Observer(
                    builder: (_) => Slider(
                      min: 1.0,
                      max: 20.0,
                      divisions: 19,
                      value: store.radiusInKm,
                      label: '${store.radiusInKm.toStringAsFixed(1)} km',
                      onChanged: (value) {
                        ctrl.updateRadius(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                    final deliveries = store.deliveries;
                    if (deliveries.isEmpty) {
                      return const Center(
                        child: Text('Nenhuma entrega próxima encontrada!'),
                      );
                    }

                    return ListView.builder(
                      itemCount: deliveries.length,
                      itemBuilder: (_, index) {
                        final shopDelivery = deliveries[index];
                        // Initialize the expanded state if not present
                        _expandedState.putIfAbsent(index, () => false);

                        return ShopCard(
                          shopInfo: shopDelivery,
                          action: ctrl.changeDeliveryStatus,
                          isExpanded: _expandedState[index]!,
                          onExpansionChanged: (isExpanded) {
                            setState(() {
                              _expandedState[index] = isExpanded;
                            });
                          },
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
                              ctrl.refreshNearbyDeliveries();
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
    );
  }
}
