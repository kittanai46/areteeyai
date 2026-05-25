import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:areteeyai/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/providers/locale_provider.dart';
import '../features/home/view_models/home_view_model.dart';
import '../features/food/view_models/food_view_model.dart';
import '../features/fresh_food/view_models/fresh_food_view_model.dart';
import '../features/delivery/view_models/delivery_view_model.dart';
import '../features/cart/view_models/cart_view_model.dart';
import '../features/orders/view_models/order_view_model.dart';
import '../features/coupons/view_models/coupon_view_model.dart';
import 'routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => FoodViewModel()),
        ChangeNotifierProvider(create: (_) => FreshFoodViewModel()),
        ChangeNotifierProvider(create: (_) => DeliveryViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        ChangeNotifierProvider(create: (_) => CouponViewModel()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (_, localeProvider, __) => MaterialApp.router(
        title: 'Aretee',
        debugShowCheckedModeBanner: false,
        locale: localeProvider.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('th'),
          Locale('en'),
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Sarabun',
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            centerTitle: false,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
        ),
      ),
    );
  }
}
