import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:x_clone/core/constants/assets_constants.dart';
import 'package:x_clone/features/auth/view/sign_in_view.dart';
import 'package:x_clone/features/auth/view/user_registration_view.dart';

class SignUpView extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 14, bottom: 30, left: 30, right: 30),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: SvgPicture.asset(AssetsConstants.blackX,
                    height: 26, width: 26),
              ),
              Column(
                children: [
                  const Text(
                    "See what's happening in the world right now.",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      UserRegistrationView.route(),
                    ),
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(300, 50),
                        backgroundColor: Colors.black),
                    child: const Text(
                      "Create account",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Have an account already?",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    child: Text(
                      "Log in",
                      style:
                          TextStyle(color: Colors.blue.shade400, fontSize: 14),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      SignInView.route(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
