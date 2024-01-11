import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/core/common/loading_page.dart';
import 'package:x_clone/core/constants/assets_constants.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/auth/widgets/details_text_field.dart';

class UserRegistrationView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const UserRegistrationView(),
      );
  const UserRegistrationView({super.key});

  @override
  ConsumerState<UserRegistrationView> createState() =>
      _UserRegistrationPageState();
}

class _UserRegistrationPageState extends ConsumerState<UserRegistrationView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  //TODO: Add DOB controller

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    void onSignUp() {
      ref.read(authControllerProvider.notifier).signUp(
            email: emailController.text,
            password: passwordController.text,
            name: nameController.text,
            context: context,
          );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          iconSize: 28,
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: SvgPicture.asset(AssetsConstants.blackX, height: 20, width: 20),
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create your account',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 20),
                      child: Form(
                        child: Column(
                          children: [
                            DetailsTextField(
                              controller: nameController,
                              hintText: 'Name',
                              labelText: 'Name',
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 30.0),
                              child: DetailsTextField(
                                controller: emailController,
                                hintText: 'Email adress',
                                labelText: 'Email adress',
                              ),
                            ),
                            DetailsTextField(
                              controller: passwordController,
                              hintText: 'Password',
                              labelText: 'Password',
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onSignUp();
                        //TODO: Add exception if user already exists
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
