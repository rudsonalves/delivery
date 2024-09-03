import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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

  @override
  void initState() {
    super.initState();
    ctrl.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ctrl.isLoggedIn) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    ctrl.dispose();

    super.dispose();
  }

  Future<void> _signIn() async {
    if (ctrl.isValid) {
      await ctrl.signIn();
      if (ctrl.state == UserState.stateSuccess) {
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          showMessageSnackBar(
            context,
            message:
                const Text('Ocorreu algum erro. Por favor, tente mais tarde!'),
          );
        }
      }
    } else {
      showMessageSnackBar(
        context,
        message: const Text('Por favor, corrija os erros no formulário.'),
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
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
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
                      onChanged: ctrl.store.setEmail,
                    ),
                    PasswordTextField(
                      controller: ctrl.passwordController,
                      labelText: 'Senha',
                      onChanged: ctrl.store.setPassword,
                    ),
                    BigButton(
                      color: Colors.green,
                      label: 'Entrar',
                      onPressed: _signIn,
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, SignUpPage.routeName),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: 'Não possui conta? '),
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
