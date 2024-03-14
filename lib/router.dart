import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:x_clone/features/auth/view/sign_in_view.dart';
import 'package:x_clone/features/home/view/home_view.dart';
import 'package:x_clone/features/posts/view/create_post_view.dart';
import 'package:x_clone/features/posts/view/image_full_view.dart';
import 'package:x_clone/features/posts/widgets/post_list.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: SignInView()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeView()),
  '/add-post': (routeData) => const MaterialPage(child: CreatePostView()),
  '/image-full-view': (routeData) =>
      const MaterialPage(child: ImageFullView(imageUrl: [])),
  '/feed-uid': (routeData) => const MaterialPage(child: PostList()),
});
