import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/common/loading_page.dart';
import 'package:x_clone/core/common/widgets/rounded_small_button.dart';
import 'package:x_clone/core/utils.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/posts/controller/post_controller.dart';

class CreatePostView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreatePostView(),
      );
  const CreatePostView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends ConsumerState<CreatePostView> {
  final postTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    postTextController.dispose();
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  void sharePost() {
    ref.read(postControllerProvider.notifier).sharePost(
        images: images, text: postTextController.text, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider)!;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          iconSize: 30,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: RoundedSmallButton(
                onTap: sharePost,
                label: 'Post',
                backgroundColor: Colors.blue.shade400,
                textColor: Colors.white),
          )
        ],
      ),
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(currentUser.profilePicture),
                            radius: 24,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextFormField(
                              autofocus: true,
                              controller: postTextController,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                hintText: "What's happening?",
                                hintStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                      if (images.isNotEmpty)
                        CarouselSlider(
                          items: images.map(
                            (file) {
                              return Container(
                                width: deviceWidth,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Image.file(file),
                              );
                            },
                          ).toList(),
                          options: CarouselOptions(
                              height: 400, enableInfiniteScroll: false),
                        ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Container(
        // padding: EdgeInsets.only(bottom:10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 0.3),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: IconButton(
                icon: Icon(
                  Icons.photo_size_select_actual_outlined,
                  size: 30,
                  color: Colors.blue.shade400,
                ),
                onPressed: onPickImages,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: Icon(
                Icons.gif_box_outlined,
                color: Colors.blue.shade400,
                size: 30,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: Icon(
                Icons.format_list_bulleted_add,
                color: Colors.blue.shade400,
                size: 30,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: Icon(
                Icons.location_on_outlined,
                color: Colors.blue.shade400,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
