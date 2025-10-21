import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/bin_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

      if (!onboardingComplete && state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }

      if (onboardingComplete && state.matchedLocation == '/') {
        return '/main';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/main'),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
      GoRoute(
        path: '/bin/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BinDetailScreen(binId: id);
        },
      ),
    ],
  );
});
