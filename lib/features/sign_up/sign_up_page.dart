import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../common/models/user.dart';
import '../../components/widgets/message_snack_bar.dart';
import '../../components/widgets/state_loading.dart';
import '../../stores/user/user_store.dart';
import '/features/sign_up/sign_up_controller.dart';
import '/components/widgets/custom_text_field.dart';
import '/components/widgets/big_bottom.dart';
import '/components/widgets/password_text_field.dart';
import '../../common/theme/app_text_style.dart';
import '../sign_in/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const routeName = '/sign_up';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ctrl = SignUpController();
  final focusNode = FocusNode();
  late ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();

    ctrl.init();

    // Reaction to monitor isLoggedIn changes
    _disposer = reaction<bool>((_) => ctrl.isLoggedIn, (isLoggedIn) {
      if (ctrl.isLoggedIn) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    ctrl.dispose();

    _disposer();
    super.dispose();
  }

  Future<void> signUp() async {
    FocusScope.of(context).nextFocus();

    if (ctrl.isValid) {
      await ctrl.signUp();
      if (ctrl.state == UserState.stateSuccess) {
        if (mounted) {
          showMessageSnackBar(
            context,
            message: 'Sua conta foi criada com sucesso.',
          );
        }
        return;
      } else {
        if (mounted) {
          showMessageSnackBar(
            context,
            message: 'Ocorreu algum erro. Por favor, tente mais tarde!',
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
        title: const Text('Cadastrar'),
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
            builder: (context) => AbsorbPointer(
              absorbing: ctrl.state == UserState.stateLoading,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Observer(
                        builder: (_) => CustomTextField(
                          labelText: 'Nome',
                          controller: ctrl.nameController,
                          textInputAction: TextInputAction.next,
                          onChanged: ctrl.pageStore.setName,
                          errorText: ctrl.pageStore.errorName,
                        ),
                      ),
                      Observer(
                        builder: (_) => CustomTextField(
                          labelText: 'Endereço de E-mail',
                          controller: ctrl.emailController,
                          textInputAction: TextInputAction.next,
                          onChanged: ctrl.pageStore.setEmail,
                          errorText: ctrl.pageStore.errorEmail,
                        ),
                      ),
                      Observer(
                        builder: (_) => CustomTextField(
                          labelText: 'Telefone',
                          controller: ctrl.phoneController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onChanged: ctrl.pageStore.setPhone,
                          errorText: ctrl.pageStore.errorPhoneNumber,
                        ),
                      ),
                      Observer(
                        builder: (_) => PasswordTextField(
                          controller: ctrl.passwordController,
                          labelText: 'Senha',
                          onChanged: ctrl.pageStore.setPassword,
                          errorText: ctrl.pageStore.errorPassword,
                          textInputAction: TextInputAction.next,
                          nextFocus: focusNode,
                        ),
                      ),
                      Observer(
                        builder: (_) => PasswordTextField(
                          controller: ctrl.passwordCheckController,
                          labelText: 'Confirme a Senha',
                          onChanged: ctrl.pageStore.setCheckPassword,
                          errorText: ctrl.pageStore.errorCheckPassword,
                          textInputAction: TextInputAction.done,
                          focusNode: focusNode,
                        ),
                      ),
                      Observer(
                        builder: (_) => DropdownButton<UserRole>(
                          value: ctrl.pageStore.role,
                          items: UserRole.values.map(
                            (role) {
                              bool enable = role != UserRole.admin
                                  ? true
                                  : ctrl.adminChecked
                                      ? false
                                      : true;
                              String title = '';
                              IconData icon;
                              switch (role) {
                                case UserRole.admin:
                                  title = 'Administrador';
                                  icon = Icons.admin_panel_settings_rounded;
                                  break;
                                case UserRole.delivery:
                                  title = 'Entregador';
                                  icon = Icons.delivery_dining_rounded;
                                  break;
                                case UserRole.client:
                                  title = 'Produtor';
                                  icon = Icons.store_outlined;
                                  break;
                                case UserRole.consumer:
                                  title = 'Consumidor';
                                  icon = Icons.person_rounded;
                                  break;
                              }
                              return DropdownMenuItem<UserRole>(
                                value: role,
                                enabled: enable,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: ListTile(
                                    title: Text(title),
                                    enabled: enable,
                                    leading: Icon(icon),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              ctrl.pageStore.setRole(value);
                            }
                          },
                        ),
                      ),
                      BigButton(
                        color: Colors.blue,
                        label: 'Cadastrar',
                        onPressed: signUp,
                      ),
                      FilledButton.tonal(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, SignInPage.routeName),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Possui conta? ',
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              TextSpan(
                                text: 'Entrar!',
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
                  if (ctrl.state == UserState.stateLoading)
                    const StateLoading(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
