import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;

  final List<Widget> _screens = const [
    HomeScreen(),
    AnalyticsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: IndexedStack(
          key: ValueKey<int>(_currentIndex),
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
              _animationController.reset();
              _animationController.forward();
            },
            elevation: 0,
            height: 70,
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            indicatorColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.15),
            animationDuration: const Duration(milliseconds: 400),
            destinations: [
              NavigationDestination(
                icon: _buildNavIcon(Icons.home_outlined, 0),
                selectedIcon: _buildNavIcon(Icons.home, 0, selected: true),
                label: 'Home',
              ),
              NavigationDestination(
                icon: _buildNavIcon(Icons.analytics_outlined, 1),
                selectedIcon: _buildNavIcon(Icons.analytics, 1, selected: true),
                label: 'Analytics',
              ),
              NavigationDestination(
                icon: _buildNavIcon(Icons.settings_outlined, 2),
                selectedIcon: _buildNavIcon(Icons.settings, 2, selected: true),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, {bool selected = false}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0.0,
        end: selected && _currentIndex == index ? 1.0 : 0.0,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: 1.0 + (value * 0.2), child: Icon(icon));
      },
    );
  }
}
