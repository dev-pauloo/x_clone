import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:x_clone/core/constants/assets_constants.dart';
import 'package:x_clone/core/constants/firebase_constants.dart';
import 'package:x_clone/core/failure.dart';
import 'package:x_clone/core/providers/firebase_providers.dart';
import 'package:x_clone/core/type_defs.dart';
import 'package:x_clone/models/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.userCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (isFromLogin) {
        userCredential = await _auth.signInWithCredential(credential);
      } else {
        userCredential =
            await _auth.currentUser!.linkWithCredential(credential);
      }

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            email: userCredential.user!.email ?? "No email",
            name: userCredential.user!.displayName ?? "",
            followers: [],
            following: [],
            profilePicture:
                userCredential.user!.photoURL ?? AssetsConstants.avatarDefault,
            bannerPicture: AssetsConstants.bannerDefault,
            bio: "",
            uid: _auth.currentUser!.uid,
            isXVerified: false);

        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e, stackTrace) {
      return left(
        FailureClass(e.toString(), stackTrace),
      );
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureEither<UserModel> registerWithEmailAndPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      var userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel userModel;
      userModel = UserModel(
          email: userCredential.user!.email ?? "No email",
          name: name,
          followers: [],
          following: [],
          profilePicture:
              userCredential.user!.photoURL ?? AssetsConstants.avatarDefault,
          bannerPicture: AssetsConstants.bannerDefault,
          bio: "",
          uid: _auth.currentUser!.uid,
          isXVerified: false);
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e, stackTrace) {
      return left(FailureClass(e.toString(), stackTrace));
    }
  }

  FutureEither<UserModel?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserModel userModel;
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      userModel = await getUserData(userCredential.user!.uid).first;
      return right(userModel);
      // final session = await _auth.signInWithEmailAndPassword(
      //     email: email, password: password);
      // return right(session.user);
    } on FirebaseAuthException catch (e, stackTrace) {
      switch (e.code) {
        case 'user-not-found':
          throw FailureClass('Invalid email address!', stackTrace);
        case 'wrong-password':
          throw FailureClass('Invalid password!', stackTrace);
        default:
          throw FailureClass('An error occurred', stackTrace);
      }
    } catch (e, stackTrace) {
      throw FailureClass(e.toString(), stackTrace);
    }

    // try {
    //   final session = await _auth.signInWithEmailAndPassword(
    //       email: email, password: password);
    //   return right(session.user);
    // } on FirebaseAuthException catch (e, stackTrace) {
    //   throw FailureClass(
    //       e.message ?? 'Some unexpected error occurred', stackTrace);
    // } catch (e, stackTrace) {
    //   throw FailureClass(e.toString(), stackTrace);
    // }
  }

  Future<User?> getCurrentUser() async {
    try {
      return _auth.currentUser;
    } on FirebaseAuthException {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
    _googleSignIn.signOut();
  }
}
