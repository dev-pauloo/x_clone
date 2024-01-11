import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x_clone/core/common/loading_page.dart';
import 'package:x_clone/core/constants/assets_constants.dart';
import 'package:x_clone/core/constants/ui_constants.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/auth/view/sign_in_view.dart';
import 'package:x_clone/features/posts/view/create_post_view.dart';
import 'package:x_clone/models/user_model.dart';

class HomeView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  void signOut() async {
    ref.read(authControllerProvider.notifier).signOut();
    final isLoading = ref.read(authControllerProvider);
    isLoading
        ? const Loader()
        : Navigator.pushNamed(context, SignInView.route());
  }

  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreatePost() {
    Navigator.push(context, CreatePostView.route());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
            ),
            onPressed: () {},
          ),
          // title: SizedBox(
          //   width: 200,
          //   child: TextFormField(
          //     style: TextStyle(),
          //     decoration: InputDecoration(hintText: 'Search X'),
          //   ),
          // ),
          // centerTitle: true,
          title: const Icon(Icons.settings),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onCreatePost,
          elevation: 0,
          shape: const CircleBorder(),
          foregroundColor: Colors.blue.shade400,
          backgroundColor: Colors.blue.shade400,
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: _page,
          onTap: onPageChange,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _page == 0
                    ? AssetsConstants.homeFilledIcon
                    : AssetsConstants.homeOutlinedIcon,
              ),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetsConstants.searchIcon),
            ),
            BottomNavigationBarItem(
              icon: _page == 2
                  ? const Icon(Icons.people_outline_outlined,
                      color: Colors.black)
                  : const Icon(Icons.people_outline, color: Colors.black),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(_page == 3
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon),
            ),
            BottomNavigationBarItem(
              icon: _page == 4
                  ? const Icon(Icons.email, color: Colors.black)
                  : const Icon(
                      Icons.email_outlined,
                      color: Colors.black,
                    ),
            ),
          ],
        ),
        body: IndexedStack(
          index: _page,
          children: UIConstants.bottomTapBarPages,
        ));
  }
}
