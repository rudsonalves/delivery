import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../home/home_page.dart';
import '/features/sign_in/sign_in_controller.dart';
import '/stores/user/user_store.dart';
import '../../common/theme/app_text_style.dart';
import '../../components/widgets/big_bottom.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/message_snack_bar.dart';
import '../../components/widgets/password_text_field.dart';
import '../../components/widgets/state_loading.dart';
import '/features/sign_up/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static const routeName = '/sign_in';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final ctrl = SignInController();
  late ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    ctrl.init();

    // Reaction to monitor isLoggedIn changes
    _disposer = reaction<bool>((_) => ctrl.userStatus, (_) {
      if (ctrl.isLoggedIn) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    });
  }

  @override
  void dispose() {
    ctrl.dispose();

    _disposer();
    super.dispose();
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    if (ctrl.isValid) {
      final result = await ctrl.signIn();
      if (result.isSuccess) {
        return;
      } else {
        final message = result.error!.message!.contains('invalid-credential')
            ? 'Verifique suas credenciais: Email e/ou Senha podem estar erradas.'
            : 'Ocorreu algum erro. Por favor, tente mais tarde!';
        if (mounted) {
          showMessageSnackBar(
            context,
            message: message,
          );
        }
      }
    } else {
      showMessageSnackBar(
        context,
        message: 'Por favor, corrija os erros no formulário.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        // leading: IconButton(
        //   onPressed: Navigator.of(context).pop,
        //   icon: const Icon(Icons.arrow_back_ios_new_rounded),
        // ),
        actions: [
          ValueListenableBuilder(
            valueListenable: ctrl.app.brightnessNotifier,
            builder: (context, value, _) => IconButton(
              isSelected: value == Brightness.dark,
              onPressed: ctrl.app.toogleBrightness,
              icon: const Icon(Icons.light_mode),
              selectedIcon: const Icon(Icons.dark_mode),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Observer(
            builder: (context) => Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      labelText: 'Endereço de E-mail',
                      controller: ctrl.emailController,
                      onChanged: ctrl.pageStore.setEmail,
                    ),
                    PasswordTextField(
                      controller: ctrl.passwordController,
                      labelText: 'Senha',
                      onChanged: ctrl.pageStore.setPassword,
                      onFieldSubmitted: _signIn,
                    ),
                    BigButton(
                      color: Colors.green,
                      label: 'Entrar',
                      onPressed: _signIn,
                    ),
                    FilledButton.tonal(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, SignUpPage.routeName),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Não possui conta? ',
                                style: TextStyle(color: colorScheme.onSurface)),
                            TextSpan(
                              text: 'Cadastrar!',
                              style: AppTextStyle.font14Bold(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (ctrl.state == UserState.stateLoading) const StateLoading(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
