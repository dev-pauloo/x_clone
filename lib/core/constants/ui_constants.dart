import 'package:flutter/material.dart';
import 'package:x_clone/features/posts/widgets/post_list.dart';

class UIConstants {
  static List<Widget> bottomTapBarPages = [
    const PostList(),
    Text('Search Screen'),
    Text('Communities Screen'),
    Text('Notification Screen'),
    Text('Messages Screen')
  ];
}
