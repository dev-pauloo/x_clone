import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:x_clone/core/enums/post_type_enum.dart';
import 'package:x_clone/core/utils.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/posts/repository/post_repository.dart';
import 'package:x_clone/models/post_model.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    ref: ref,
    postRepository: ref.watch(postRepositoryProvider),
  );
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  PostController({required Ref ref, required PostRepository postRepository})
      : _ref = ref,
        _postRepository = postRepository,
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
      _shareImagePost(images: images, text: text, context: context);
    } else {
      _shareTextPost(text: text, context: context);
    }
  }

  void _shareImagePost({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(userProvider)!;

    Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLink: const [],
      uid: user.uid,
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

  void _shareTextPost({
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(userProvider)!;

    Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLink: const [],
      uid: user.uid,
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
}
