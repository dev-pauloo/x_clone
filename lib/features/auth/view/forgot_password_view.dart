import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ForgotPasswordPage(),
      );
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_sharp),
          iconSize: 28,
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: SvgPicture.asset('lib/assets/x-black-icon.svg',
            height: 20, width: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find your X account',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                      'Enter the email, phone number or username associated with your account to change your password.'),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email address, phone number...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.black26)),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
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
