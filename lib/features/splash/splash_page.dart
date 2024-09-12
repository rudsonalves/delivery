import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '/features/splash/splash_controller.dart';
import '../../stores/user/user_store.dart';
import '/features/home/home_page.dart';
import '/features/sign_in/sign_in_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  final ctrl = SplashController();

  late ReactionDisposer _disposer;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    _disposer = reaction<bool>(
      (_) => ctrl.userStatus,
      (_) async {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          if (ctrl.isLoggedIn) {
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          } else {
            Navigator.pushReplacementNamed(context, SignInPage.routeName);
          }
        }
      },
    );

    ctrl.init();
  }

  @override
  void dispose() {
    _disposer();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Observer(builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: AnimatedIcon(
                icon: AnimatedIcons.home_menu,
                progress: animation,
                size: 150,
                color: colorScheme.primary,
              ),
            ),
            if (ctrl.state == UserState.stateLoading)
              const CircularProgressIndicator(),
          ],
        );
      }),
    );
  }
}
