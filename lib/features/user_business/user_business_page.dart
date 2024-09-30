import 'package:delivery/stores/pages/common/store_func.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../common/theme/app_text_style.dart';
import '../../locator.dart';
import '../../stores/pages/user_business_store.dart';
import '../../stores/user/user_store.dart';
import '/components/widgets/delivery_card.dart';
import '/features/user_business/user_business_controller.dart';
import '../../common/models/delivery.dart';
import '../add_delivery/add_delivery_page.dart';
import '../map/map_page.dart';

class UserBusinessPage extends StatefulWidget {
  const UserBusinessPage({super.key});

  @override
  State<UserBusinessPage> createState() => _UserBusinessPageState();
}

class _UserBusinessPageState extends State<UserBusinessPage> {
  late final UserBusinessController ctrl;
  final store = UserBusinessStore();
  final _currentUser = locator<UserStore>().currentUser;
  late final String userId;

  @override
  void initState() {
    super.initState();

    if (_currentUser == null) {
      // FIXME: At some point it will go wrong!
      return;
    }
    userId = _currentUser.id!;
    ctrl = UserBusinessController(store: store);
    ctrl.init(userId);
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  void _showInMap(DeliveryModel delivery) {
    Navigator.pushNamed(context, MapPage.routeName, arguments: delivery);
  }

  void _addDelivery() {
    // Navigator.pushNamed(context, PersonDataPage.routeName);
    Navigator.pushNamed(context, AddDeliveryPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addDelivery,
        child: const Icon(Icons.delivery_dining_rounded),
      ),
      body: Column(
        children: [
          Expanded(
            child: Observer(
              builder: (_) {
                switch (store.pageState) {
                  case PageState.initial:
                  case PageState.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case PageState.success:
                    final deliveries = store.deliveries;
                    if (deliveries.isEmpty) {
                      return const Center(
                        child: Text('Nenhuma entrega encontrada!'),
                      );
                    }
                    return ListView.builder(
                      itemCount: deliveries.length,
                      itemBuilder: (_, index) {
                        final delivery = deliveries[index];

                        return DeliveryCard(
                          delivery: delivery,
                          showInMap: _showInMap,
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
    );
  }
}
