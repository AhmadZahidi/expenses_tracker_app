import 'package:expenses_tracker_app/screens/add_screen.dart';
import 'package:expenses_tracker_app/screens/editDelete_screen.dart';
import 'package:expenses_tracker_app/screens/home_screen.dart';
import 'package:expenses_tracker_app/screens/report_screen.dart';
import 'package:expenses_tracker_app/screens/splash_screen.dart';
import 'package:expenses_tracker_app/screens/test_screen.dart';
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
      builder: (context, state) => const LoginScreen(),
      // const HomeScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/home/add', builder: (context, state) => AddScreen()),
    GoRoute(
      path: '/home/editDelete',
      builder: (context, state) {
        final item = state.extra as Map<String, dynamic>;
        return EditdeleteScreen(expenseData: item);
      },
    ),

    GoRoute(path: '/report', builder: (context, state) => ReportScreen()),
  ],
);
