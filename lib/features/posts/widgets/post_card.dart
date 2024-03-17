import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:x_clone/core/common/error_page.dart';
import 'package:x_clone/core/common/loading_page.dart';
import 'package:x_clone/core/constants/assets_constants.dart';
import 'package:x_clone/core/enums/post_type_enum.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/posts/controller/post_controller.dart';
import 'package:x_clone/features/posts/widgets/carousel_image.dart';
import 'package:x_clone/features/posts/widgets/hashtag_text.dart';
import 'package:x_clone/features/posts/widgets/post_icon_button.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends ConsumerWidget {
  final Post post;
  final String uid;
  const PostCard({required this.post, required this.uid, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null
        ? const SizedBox()
        : ref.watch(getUserDataProvider(post.uid)).when(
            data: (user) {
              return GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.profilePicture),
                              radius: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //TODO: reposted
                              Row(
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
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
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child:
                                      CarouselImage(imageLinks: post.imageLink),
                                ),
                              if (post.link!.isNotEmpty) ...[
                                const SizedBox(
                                  height: 4,
                                ),
                                AnyLinkPreview(
                                  link: 'htttps:/${post.link}',
                                ),
                              ],
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    PostIconButton(
                                      pathName: AssetsConstants.commentIcon,
                                      text: post.commentIds!.length.toString(),
                                      onTap: () {},
                                    ),
                                    PostIconButton(
                                      pathName: AssetsConstants.retweetIcon,
                                      text: post.resharedCount.toString(),
                                      onTap: () {},
                                    ),
                                    LikeButton(
                                      size: 18,
                                      onTap: (isLiked) async {
                                        ref.read(
                                            postControllerProvider.notifier);
                                        return !isLiked;
                                      },
                                      isLiked:
                                          post.likes!.contains(currentUser.uid),
                                      likeBuilder: (isLiked) {
                                        return isLiked
                                            ? SvgPicture.asset(
                                                AssetsConstants.likeFilledIcon,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Colors.red,
                                                        BlendMode.srcIn))
                                            : SvgPicture.asset(
                                                AssetsConstants
                                                    .likeOutlinedIcon,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Colors.grey,
                                                        BlendMode.srcIn));
                                      },
                                      likeCount: post.likes!.length,
                                      countBuilder: (likeCount, isLiked, text) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2),
                                          child: Text(
                                            text,
                                            style: TextStyle(
                                                color: isLiked
                                                    ? Colors.red
                                                    : Colors.black,
                                                fontSize: 14),
                                          ),
                                        );
                                      },
                                    ),
                                    PostIconButton(
                                      pathName: AssetsConstants.viewsIcon,
                                      text: (post.commentIds!.length +
                                              post.resharedCount! +
                                              post.likes!.length)
                                          .toString(),
                                      onTap: () {},
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.share_outlined,
                                          size: 18, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color.fromARGB(154, 198, 198, 198),
                    ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader());
  }
}
