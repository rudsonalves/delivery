import 'package:flutter/material.dart';

import '../../common/theme/app_text_style.dart';
import '../../components/widgets/big_bottom.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/password_text_field.dart';
import '/features/sign_up/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static const routeName = '/sign_in';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                labelText: 'Endereço de E-mail',
                controller: emailController,
              ),
              PasswordTextField(
                controller: passwordController,
                labelText: 'Senha',
              ),
              BigButton(
                color: Colors.green,
                label: 'Entrar',
                onPressed: () {},
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
        ),
      ),
    );
  }
}
