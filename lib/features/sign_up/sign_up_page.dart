import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../components/widgets/message_snack_bar.dart';
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

  @override
  void initState() {
    super.initState();

    ctrl.init();
  }

  @override
  void dispose() {
    ctrl.dispose();

    super.dispose();
  }

  Future<void> signUp() async {
    FocusScope.of(context).nextFocus();

    if (ctrl.isValid) {
      await ctrl.signUp();
      if (ctrl.state == UserState.stateSuccess) {
        if (mounted) {
          Navigator.pop(context);
        }

        if (mounted) {
          showMessageSnackBar(
            context,
            message: const Text('Sua conta foi criada com sucesso.'),
          );
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
                          onChanged: ctrl.singUpStore.setName,
                          errorText: ctrl.singUpStore.errorName,
                        ),
                      ),
                      Observer(
                        builder: (_) => CustomTextField(
                          labelText: 'Endereço de E-mail',
                          controller: ctrl.emailController,
                          textInputAction: TextInputAction.next,
                          onChanged: ctrl.singUpStore.setEmail,
                          errorText: ctrl.singUpStore.errorEmail,
                        ),
                      ),
                      // Observer(
                      //   builder: (_) => CustomTextField(
                      //     labelText: 'Telefone',
                      //     controller: ctrl.phoneController,
                      //     textInputAction: TextInputAction.next,
                      //     keyboardType: TextInputType.number,
                      //     onChanged: ctrl.singUpStore.setPhoneNumber,
                      //     errorText: ctrl.singUpStore.errorPhoneNumber,
                      //   ),
                      // ),
                      Observer(
                        builder: (_) => PasswordTextField(
                          controller: ctrl.passwordController,
                          labelText: 'Senha',
                          onChanged: ctrl.singUpStore.setPassword,
                          errorText: ctrl.singUpStore.errorPassword,
                          textInputAction: TextInputAction.next,
                          nextFocus: focusNode,
                        ),
                      ),
                      Observer(
                        builder: (_) => PasswordTextField(
                          controller: ctrl.passwordCheckController,
                          labelText: 'Confirme a Senha',
                          onChanged: ctrl.singUpStore.setCheckPassword,
                          errorText: ctrl.singUpStore.errorCheckPassword,
                          textInputAction: TextInputAction.done,
                          focusNode: focusNode,
                        ),
                      ),
                      BigButton(
                        color: Colors.blue,
                        label: 'Cadastrar',
                        onPressed: signUp,
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, SignInPage.routeName),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(text: 'Possui conta? '),
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
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
