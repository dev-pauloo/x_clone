import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:x_clone/core/common/error_page.dart';
import 'package:x_clone/core/common/loading_page.dart';
import 'package:x_clone/features/auth/controller/auth_controller.dart';
import 'package:x_clone/features/auth/view/sign_in_view.dart';
import 'package:x_clone/features/home/view/home_view.dart';
import 'package:x_clone/firebase_options.dart';
import 'package:x_clone/models/user_model.dart';
import 'package:x_clone/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (data != null) {
                  getData(ref, data);
                  if (userModel != null) {
                    return loggedInRoute;
                  }
                }
                return loggedOutRoute;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
    // final authController = ref.watch(authControllerProvider.notifier);
    // final authStateChangesStream = authController.stream;

    // return StreamBuilder<bool>(
    //   stream: authStateChangesStream,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const LoadingPage(); // Show loading indicator
    //     } else if (snapshot.hasError) {
    //       return ErrorPage(error: snapshot.error.toString()); // Handle errors
    //     } else {
    //       return MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         home: snapshot.hasData && snapshot.data != null
    //             ? const HomeView() // User is signed in, show HomeView
    //             : const SignUpView(), // User is not signed in, show SignUpView
    //       );
    //     }
    //   },
    // );

