import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/core/common/loading_page.dart';
import 'package:x_clone/core/constants/assets_constants.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/auth/view/forgot_password_view.dart';
import 'package:x_clone/features/auth/view/sign_up_view.dart';
import 'package:x_clone/features/auth/widgets/details_text_field.dart';
import 'package:x_clone/features/home/view/home_view.dart';

class SignInView extends ConsumerWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignInView(),
      );
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final isLoading = ref.watch(authControllerProvider);
    final bool isButtonEnabled = false;

    void onSignIn() {
      ref
          .read(authControllerProvider.notifier)
          .signIn(email: emailController.text, password: passwordController.text, context: context);
      Navigator.pushReplacement(context, HomeView.route());
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_sharp),
          iconSize: 28,
          onPressed: () => Navigator.pushReplacement(context, SignUpView.route()),
        ),
        centerTitle: true,
        title: SvgPicture.asset(AssetsConstants.blackX, height: 20, width: 20),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'To get started, first enter your phone, email address or @username',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        DetailsTextField(
                          controller: emailController,
                          hintText: 'Email adress',
                          labelText: 'Email adress',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DetailsTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          labelText: 'Password',
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.push(
                                context, ForgotPasswordPage.route()),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: Colors.black26),
                              ),
                            ),
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                            onPressed: onSignIn,
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.black),
                            child: const Text(
                              'Next',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
