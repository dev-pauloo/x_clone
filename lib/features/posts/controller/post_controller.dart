import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:x_clone/core/enums/post_type_enum.dart';
import 'package:x_clone/core/providers/storage_repository_provider.dart';
import 'package:x_clone/core/utils.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/posts/repository/post_repository.dart';
import 'package:x_clone/models/post_model.dart';
import 'package:x_clone/models/user_model.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    ref: ref,
    postRepository: ref.watch(postRepositoryProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  );
});

final userPostProvider = StreamProvider((
  ref,
) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts();
});

final postsStateProvider = StateProvider<AsyncValue<List<Post>>>(
  (_) => const AsyncValue.loading(),
);

final currentUserPostsStateProvider = StateProvider<AsyncValue<List<Post>>>(
  (_) => const AsyncValue.loading(),
);

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController(
      {required Ref ref,
      required PostRepository postRepository,
      required StorageRepository storageRepository})
      : _ref = ref,
        _postRepository = postRepository,
        _storageRepository = storageRepository,
        super(false);

  void sharePost({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text!');
      return;
    }
    if (images.isNotEmpty) {
      _shareImagePost(
        images: images,
        text: text,
        context: context,
      );
    } else {
      _shareTextPost(text: text, context: context);
    }
  }

  void _shareTextPost({
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.watch(userProvider);

    Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLink: const [],
      uid: user!.uid,
      postType: PostType.text,
      postedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: postId,
      resharedCount: 0,
    );
    final res = await _postRepository.addPost(post);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'Posted successfully!'),
    );
    Navigator.pop(context);
  }

  void _shareImagePost({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    String postId = const Uuid().v4().trim();
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(userProvider);

    try {
      List<String?>? imageLinks = await _storageRepository.storeFiles(
        path: "posts/${user!.uid}",
        id: postId,
        files: images,
      );

      print('Image Links: $imageLinks');

      final Post post = Post(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLink: imageLinks,
        uid: user.uid,
        postType: PostType.image,
        postedAt: DateTime.now(),
        likes: const [],
        commentIds: const [],
        id: postId,
        resharedCount: 0,
      );

      final res = await _postRepository.addPost(post);

      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, 'Posted successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, 'An error occurred while sharing the post.');
    } finally {
      state = false;
    }
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  Stream<List<Post>> fetchUserPosts() {
    final postList = _postRepository.fetchUserPosts();
    return postList;
  }

  void likePost(Post post, UserModel user) async {
    List<String?>? likes = post.likes;

    if (post.likes!.contains(user.uid)) {
      likes!.remove(user.uid);
    } else {
      likes!.add(user.uid);
    }

    post = post.copyWith(likes: likes);
    final res = await _postRepository.likePost(post);
    res.fold((l) => null, (r) {});
  }
}
