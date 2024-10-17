// Copyright (C) 2024 Rudson Alves
// 
// This file is part of delivery.
// 
// delivery is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// delivery is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with delivery.  If not, see <https://www.gnu.org/licenses/>.

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
        String message;
        switch (result.error!.code) {
          case 200:
            message =
                'Sua conta ainda não verificada. Acesse seu email para concluir sua verificação.';
            break;
          case 202:
            message = 'Verifique seu email e senha e tente novamente.';
            break;
          case 204:
            message =
                'Suas credenciais estão incorretas. Verifique seu email e senha e tente novamente.';
          default:
            message = 'Ocorreu algum erro. Por favor, tente mais tarde!';
        }
        if (mounted) {
          showMessageSnackBar(
            context,
            msg: message,
          );
        }
      }
    } else {
      showMessageSnackBar(context,
          msg: 'Por favor, corrija os erros no formulário.');
    }
  }

  void _resendVerifEmail() {
    FocusScope.of(context).unfocus();
    if (ctrl.pageStore.isEmailValid()) {
      showMessageSnackBar(
        context,
        time: 5,
        title: 'Recuperar Senha',
        msg: 'Enviamos um novo e-mail de verificação para o seu'
            ' endereço de e-mail cadastrado. Por favor, verifique sua caixa'
            ' de entrada (e a pasta de spam) e siga as instruções para'
            ' confirmar seu e-mail. Caso não receba o e-mail, tente'
            ' novamente em alguns minutos.: ',
      );
      ctrl.resendVerificationEmail();
    }
  }

  void _recoverPassword() {
    final colorScheme = Theme.of(context).colorScheme;

    FocusScope.of(context).unfocus();
    if (ctrl.pageStore.isEmailValid()) {
      showMessageSnackBar(
        context,
        time: 5,
        title: 'Recuperar Senha',
        msgWidget: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Um e-mail de redefinição de senha foi enviado para: ',
                style: AppTextStyle.font15(color: colorScheme.onSurface),
              ),
              TextSpan(
                text: '"${ctrl.pageStore.email}"',
                style: AppTextStyle.font15Bold(color: colorScheme.primary),
              ),
            ],
          ),
        ),
      );
      ctrl.sendPasswordResetEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
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
                      errorText: ctrl.pageStore.errorEmail,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: ctrl.focusNode,
                      nextFocusNode: ctrl.nextFocusNode,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _recoverPassword,
                          child: Text(
                            ' Recuperar senha! ',
                            style: AppTextStyle.font12Bold(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _resendVerifEmail,
                          child: Text(
                            ' Reenviar E-mail de Verificação ',
                            style: AppTextStyle.font12Bold(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    PasswordTextField(
                      controller: ctrl.passwordController,
                      focusNode: ctrl.nextFocusNode,
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
