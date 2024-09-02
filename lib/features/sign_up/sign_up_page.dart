import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../stores/user/user_store.dart';
import '/components/widgets/custom_text_field.dart';
import '/components/widgets/big_bottom.dart';
import '/components/widgets/password_text_field.dart';
import '/stores/mobx/sign_up_store.dart';
import '../../common/theme/app_text_style.dart';
import '../sign_in/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const routeName = '/sign_up';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();

  final singUpStore = SignUpStore();
  final userStore = UserStore();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Observer(
                builder: (_) => CustomTextField(
                  labelText: 'Nome',
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  onChanged: singUpStore.setName,
                  errorText: singUpStore.errorName,
                ),
              ),
              Observer(
                builder: (_) => CustomTextField(
                  labelText: 'Endereço de E-mail',
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  onChanged: singUpStore.setEmail,
                  errorText: singUpStore.errorEmail,
                ),
              ),
              Observer(
                builder: (_) => PasswordTextField(
                  controller: passwordController,
                  labelText: 'Senha',
                  onChanged: singUpStore.setPassword,
                  errorText: singUpStore.errorPassword,
                  textInputAction: TextInputAction.next,
                ),
              ),
              Observer(
                builder: (_) => PasswordTextField(
                  controller: passwordCheckController,
                  labelText: 'Confirme a Senha',
                  onChanged: singUpStore.setCheckPassword,
                  errorText: singUpStore.errorCheckPassword,
                  textInputAction: TextInputAction.done,
                ),
              ),
              BigButton(
                color: Colors.blue,
                label: 'Cadastrar',
                onPressed: () async {
                  userStore.signUp(
                    emailController.text,
                    passwordController.text,
                  );
                },
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
        ),
      ),
    );
  }
}
