// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:x_clone/features/auth/controller/auth_controller.dart';
// import 'package:x_clone/features/auth/view/forgot_password_view.dart';
// import 'package:x_clone/features/auth/view/sign_in_view.dart';
// import 'package:x_clone/features/auth/view/sign_up_view.dart';
// import 'package:x_clone/features/auth/view/user_registration_view.dart';
// import 'package:x_clone/features/home/view/home_view.dart';

// // final router = GoRouter(
// //   initialLocation: '/user/signUp',
// //   routes: [
// //     GoRoute(
// //       name: 'signUpView',
// //       path: '/user/signUp',
// //       builder: (context, state) => const SignUpView(),
// //     ),
// //     GoRoute(
// //       name: 'signInView',
// //       path: '/user/signIn',
// //       builder: (context, state) => const SignInView(),
// //     ),
// //     GoRoute(
// //       name: 'userRegistrationView',
// //       path: '/user/userRegistration',
// //       builder: (context, state) => const UserRegistrationView(),
// //     ),
// //     GoRoute(
// //       name: 'forgotPasswordView',
// //       path: '/user/forgotPassword',
// //       builder: (context, state) => const ForgotPasswordPage(),
// //     ),
// //     GoRoute(
// //       name: 'homeView',
// //       path: '/user/home',
// //       builder: (context, state) => const HomeView(),
// //     ),
// //   ],
// // );

// final routeProvider = Provider<GoRouter>((ref) {
//   final authState = ref.watch(authControllerProvider);
//   return GoRouter(
//     initialLocation: '/user/signUp',
//     routes: [
//       GoRoute(
//         name: 'signUpView',
//         path: '/user/signUp',
//         builder: (context, state) => const SignUpView(),
//       ),
//       GoRoute(
//         name: 'signInView',
//         path: '/user/signIn',
//         builder: (context, state) => const SignInView(),
//       ),
//       GoRoute(
//         name: 'userRegistrationView',
//         path: '/user/userRegistration',
//         builder: (context, state) => const UserRegistrationView(),
//       ),
//       GoRoute(
//         name: 'forgotPasswordView',
//         path: '/user/forgotPassword',
//         builder: (context, state) => const ForgotPasswordPage(),
//       ),
//       GoRoute(
//         name: 'homeView',
//         path: '/user/home',
//         builder: (context, state) => const HomeView(),
//       ),
//     ],
//     redirect: (context, state) {
//       final isAuthenticated  = authState.
//     }
//   );
  
// });
