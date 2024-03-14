import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/common/error_page.dart';
import 'package:x_clone/core/common/loading_page.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/posts/controller/post_controller.dart';
import 'package:x_clone/features/posts/widgets/post_card.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(userProvider)!.uid;
    final user = ref.watch(getUserDataProvider(uid));
    return ref.watch(userPostProvider).when(
        data: (posts) {
          return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                final post = posts[index];
                // return Text('post ${post.text}');
                return PostCard(post: post, uid: uid);
              });
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
