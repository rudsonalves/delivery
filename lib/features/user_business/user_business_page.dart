import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../components/widgets/custom_app_bar/custom_app_bar.dart';
import '../../components/widgets/main_drawer/custom_drawer.dart';
import '../delivery_qrcode/delivery_qrcode.dart';
import '../../components/widgets/delivery_card.dart';
import '/stores/common/store_func.dart';
import '../../common/theme/app_text_style.dart';
import '../../locator.dart';
import 'stores/user_business_store.dart';
import '../../stores/user/user_store.dart';
import '../user_business/user_business_controller.dart';
import '../../common/models/delivery.dart';
import '../add_delivery/add_delivery_page.dart';
import '../map/map_page.dart';

class UserBusinessPage extends StatefulWidget {
  final PageController pageController;

  const UserBusinessPage(
    this.pageController, {
    super.key,
  });

  @override
  State<UserBusinessPage> createState() => _UserBusinessPageState();
}

class _UserBusinessPageState extends State<UserBusinessPage> {
  final ctrl = UserBusinessController();
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
    ctrl.init(store, userId);
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
    Navigator.pushNamed(context, AddDeliveryPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Comerciante'),
        elevation: 5,
      ),
      drawer: CustomDrawer(widget.pageController),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDelivery,
        child: const Icon(Icons.delivery_dining_rounded),
      ),
      body: Column(
        children: [
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
                        child: Text('Nenhuma entrega encontrada!'),
                      );
                    }

                    return ListView.builder(
                      itemCount: deliveries.length,
                      itemBuilder: (_, index) {
                        final delivery = deliveries[index];

                        return DeliveryCard(
                          delivery: delivery,
                          action: _showInMap,
                          qrCodeButton: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                DeliveryQrcode.routeName,
                                arguments: delivery,
                              );
                            },
                            icon: const Icon(Icons.print),
                          ),
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
                              // FIXME: ctrl.refresh(userId, store.radiusInKm);
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
