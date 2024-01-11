import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarWidget {
  static AppBar appBar() {
    return AppBar(
        centerTitle: true,
        title: SvgPicture.asset('lib/assets/x-black-icon.svg', height: 30, width: 30),
    );
  }
}
