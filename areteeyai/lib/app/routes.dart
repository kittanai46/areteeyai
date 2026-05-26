import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:areteeyai/l10n/app_localizations.dart';
import '../features/home/views/home_screen.dart';
import '../features/food/views/food_screen.dart';
import '../features/delivery/views/delivery_screen.dart';
import '../features/fresh_food/views/fresh_food_screen.dart';
import '../features/cart/views/cart_screen.dart';
import '../features/orders/views/orders_screen.dart';
import '../features/profile/views/profile_screen.dart';
import '../features/coupons/views/coupon_screen.dart';
import '../features/restaurant/views/restaurant_detail_screen.dart';
import '../core/constants/app_colors.dart';
import '../core/services/restaurant_data.dart';

/// Routes that show the bottom navigation bar
const _bottomNavRoutes = ['/', '/coupons', '/orders', '/profile'];

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          _ScaffoldWithNavBar(location: state.matchedLocation, child: child),
      routes: [
        GoRoute(path: '/',          builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/orders',    builder: (_, __) => const OrdersScreen()),
        GoRoute(path: '/cart',      builder: (_, __) => const CartScreen()),
        GoRoute(path: '/coupons',   builder: (_, __) => const CouponScreen()),
        GoRoute(path: '/profile',   builder: (_, __) => const ProfileScreen()),
        GoRoute(path: '/food',      builder: (_, __) => const FoodScreen()),
        GoRoute(path: '/delivery',  builder: (_, __) => const DeliveryScreen()),
        GoRoute(path: '/fresh-food',builder: (_, __) => const FreshFoodScreen()),
        GoRoute(
          path: '/restaurant/:id',
          builder: (_, state) {
            final id = state.pathParameters['id']!;
            final restaurant = RestaurantData.findById(id);
            if (restaurant == null) return const SizedBox.shrink();
            return RestaurantDetailScreen(restaurant: restaurant);
          },
        ),
      ],
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  final String location;
  final Widget child;

  const _ScaffoldWithNavBar({
    required this.location,
    required this.child,
  });

  bool get _showNavBar => _bottomNavRoutes.contains(location);

  int get _currentIndex {
    if (location == '/coupons') return 1;
    if (location == '/orders') return 2;
    if (location == '/profile') return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: child,
        bottomNavigationBar: _showNavBar
            ? BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (i) {
                  switch (i) {
                    case 0: context.go('/');
                    case 1: context.go('/coupons');
                    case 2: context.go('/orders');
                    case 3: context.go('/profile');
                  }
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.textHint,
                backgroundColor: AppColors.surface,
                elevation: 8,
                items: [
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.home_outlined),
                      activeIcon: const Icon(Icons.home),
                      label: l10n.navHome),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.local_offer_outlined),
                      activeIcon: const Icon(Icons.local_offer),
                      label: l10n.navCoupons),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.receipt_long_outlined),
                      activeIcon: const Icon(Icons.receipt_long),
                      label: l10n.navOrders),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.person_outline),
                      activeIcon: const Icon(Icons.person),
                      label: l10n.navProfile),
                ],
              )
            : null,
      ),
    );
  }
}
