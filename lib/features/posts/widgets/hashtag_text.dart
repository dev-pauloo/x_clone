import 'package:flutter/material.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpan = [];

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textSpan.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        );
      } else if (element.startsWith('www.') || element.startsWith('https://')) {
        textSpan.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(fontSize: 16, color: Colors.blue),
          ),
        );
      } else {
        textSpan.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
          ),
        );
      }
    });

    return RichText(
      text: TextSpan(children: textSpan),
    );
  }
}
