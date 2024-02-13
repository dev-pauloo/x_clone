import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/common/error_page.dart';
import 'package:x_clone/core/common/loading_page.dart';
import 'package:x_clone/core/enums/post_type_enum.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/home/view/home_view.dart';
import 'package:x_clone/features/posts/controller/post_controller.dart';
import 'package:x_clone/features/posts/widgets/carousel_image.dart';
import 'package:x_clone/features/posts/widgets/hashtag_text.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends ConsumerWidget {
  final Post post;
  final String uid;
  const PostCard({required this.post, required this.uid, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getUserDataProvider(post.uid)).when(
        data: (user) {
          return GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePicture),
                          radius: 35,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //reposted
                          Row(
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  '@${user.name}  ·  ${timeago.format(post.postedAt, locale: 'en_short')}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w300,
                                      color: Colors.grey[500]),
                                ),
                              ),
                            ],
                          ),
                          //replied to
                          // Row(
                          //   children: [
                          //     Text(post.text),

                          //   ],
                          // ),
                          HashtagText(text: post.text),
                          if (post.postType == PostType.image)
                            CarouselImage(imageLinks: post.imageLink),
                          // Image.network(post.imageLink!),
                          if (post.link!.isNotEmpty) ...[
                            const SizedBox(
                              height: 4,
                            ),
                            AnyLinkPreview(
                              link: 'htttps:/${post.link}',
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
