import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:x_clone/core/constants/firebase_constants.dart';
import 'package:x_clone/core/failure.dart';
import 'package:x_clone/core/providers/firebase_providers.dart';
import 'package:x_clone/core/type_defs.dart';
import 'package:x_clone/models/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.userCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(
        _posts.doc(post.id).set(
              post.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw (e.message!);
    } catch (e, stackTrace) {
      return left(FailureClass(e.toString(), stackTrace));
    }
  }
}
