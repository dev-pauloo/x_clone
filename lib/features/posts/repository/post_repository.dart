// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:x_clone/core/constants/firebase_constants.dart';
// import 'package:x_clone/core/failure.dart';
// import 'package:x_clone/core/providers/firebase_providers.dart';
// import 'package:x_clone/core/type_defs.dart';
// import 'package:x_clone/models/post_model.dart';

// final postRepositoryProvider = Provider((ref) {
//   return PostRepository(firestore: ref.watch(firestoreProvider));
// });

// class PostRepository {
//   final FirebaseFirestore _firestore;
//   PostRepository({required FirebaseFirestore firestore})
//       : _firestore = firestore;

//   CollectionReference get _posts =>
//       _firestore.collection(FirebaseConstants.postsCollection);
//   CollectionReference get _users =>
//       _firestore.collection(FirebaseConstants.userCollection);

//   FutureVoid addPost(Post post) async {
//     try {
//       return right(
//         _posts.doc(post.id).set(
//               post.toMap(),
//             ),
//       );
//     } on FirebaseException catch (e) {
//       throw (e.message!);
//     } catch (e, stackTrace) {
//       return left(FailureClass(e.toString(), stackTrace));
//     }
//   }

//   Stream<List<Post>> fetchUserPosts() {
//     return _posts
//         .orderBy('postedAt', descending: true)
//         .snapshots()
//         .map((event) => event.docs
//             .map(
//               (e) => Post.fromMap(e.data()! as Map<String, dynamic>),
//             )
//             .toList());
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:x_clone/core/constants/firebase_constants.dart';
import 'package:x_clone/core/failure.dart';
import 'package:x_clone/core/providers/firebase_providers.dart';
import 'package:x_clone/core/type_defs.dart';
import 'package:x_clone/models/post_model.dart'; // Use rxdart instead of fpdart

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  Future<Either<FailureClass, void>> addPost(Post post) async {
    try {
      await _posts.doc(post.id).set(post.toMap());
      return right(null); // Return unit instead of right(void)
    } on FirebaseException catch (e) {
      return left(
          FailureClass(e.message ?? 'Firebase error', StackTrace.current));
    } catch (e, stackTrace) {
      return left(FailureClass(e.toString(), stackTrace));
    }
  }

  Stream<List<Post>> fetchUserPosts() {
    final snapshots = _posts.orderBy('postedAt', descending: true).snapshots();

    return snapshots.map((event) => event.docs
        .map((doc) => Post.fromMap(doc.data()! as Map<String, dynamic>))
        .toList());
  }

  Future<Either<FailureClass, DocumentReference>> likePost(Post post) async {
    final collectionReference = _posts;
    final documentReference = _posts.doc(post.id);
    try {
      final documentSnapshot = await documentReference.get();

      final likes = post.likes!;

      await FirebaseFirestore.instance.runTransaction(
        (Transaction transaction) async {
          final document = transaction.get(documentReference);
          transaction.update(documentReference, {'likes': likes});
        },
      );
      return right(documentReference);
    } on FirebaseException catch (e, stackTrace) {
      return left(FailureClass(e.toString(), stackTrace));
    }
  }
}
