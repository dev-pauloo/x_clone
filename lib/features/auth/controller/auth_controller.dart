import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_clone/core/utils.dart';
import 'package:x_clone/features/auth/repository/auth_repository.dart';
import 'package:x_clone/features/auth/view/sign_in_view.dart';
import 'package:x_clone/features/home/view/home_view.dart';
import 'package:x_clone/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(userProvider)!.uid;
  final userDetails =
      ref.watch(authControllerProvider.notifier).getUserData(currentUserId);
  return userDetails;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle(true);
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void signUp({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authRepository.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        showSnackBar(context, 'Account created! Please login.');
        Navigator.push(context, SignInView.route());
      },
    );
  }

  void signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(
        context,
        l.message.toString(),
      ),
      (r) => Navigator.pushNamed(
        context,
        HomeView.route(),
      ),
    );
  }

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void signOut() async {
    await _authRepository.logOut();
  }
}
