import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/screens/add_screen.dart';
import 'package:expenses_tracker_app/screens/background_screen.dart';
import 'package:expenses_tracker_app/screens/firestore_screen.dart';
import 'package:expenses_tracker_app/screens/home_screen.dart';
import 'package:expenses_tracker_app/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
// import 'screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/',
      builder:
          (context, state) =>
              // BackgroundScreen(greenBackground, const LoginScreen()),
              const HomeScreen(),
    ),
    GoRoute(
      path: '/register',
      builder:
          (context, state) =>
              BackgroundScreen(greenBackground, const RegisterScreen()),
    ),
    GoRoute(path: '/home', builder: (context, state) => FirestoreScreen()),
    GoRoute(path: '/home/add',builder: (context, state) => AddScreen(),)
  ],
);
