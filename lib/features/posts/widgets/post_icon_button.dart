import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostIconButton extends StatelessWidget {
  final String pathName;
  final String text;
  final VoidCallback onTap;
  const PostIconButton(
      {super.key,
      required this.pathName,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            pathName,
            color: Colors.grey,
            width: 18,
            height: 18,
          ),
          Container(
            margin: const EdgeInsets.all(6),
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
