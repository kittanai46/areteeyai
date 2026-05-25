import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Aretee'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Easy order, fast delivery, fresh goods'**
  String get tagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navCoupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get navCoupons;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get greeting;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search food, products, services...'**
  String get searchHint;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @popularItems.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popularItems;

  /// No description provided for @nearbyRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Nearby Restaurants'**
  String get nearbyRestaurants;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get categoryDelivery;

  /// No description provided for @categoryFreshFood.
  ///
  /// In en, this message translates to:
  /// **'Fresh Food'**
  String get categoryFreshFood;

  /// No description provided for @categoryCoupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get categoryCoupons;

  /// No description provided for @foodTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Food'**
  String get foodTitle;

  /// No description provided for @foodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delicious food, delivered to your door'**
  String get foodSubtitle;

  /// No description provided for @restaurantList.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get restaurantList;

  /// No description provided for @menuItems.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuItems;

  /// No description provided for @deliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Service'**
  String get deliveryTitle;

  /// No description provided for @deliverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send parcels, fast & safe'**
  String get deliverySubtitle;

  /// No description provided for @sendPackage.
  ///
  /// In en, this message translates to:
  /// **'Send Parcel'**
  String get sendPackage;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Parcel'**
  String get trackOrder;

  /// No description provided for @pickupAddress.
  ///
  /// In en, this message translates to:
  /// **'Pickup Address'**
  String get pickupAddress;

  /// No description provided for @dropoffAddress.
  ///
  /// In en, this message translates to:
  /// **'Drop-off Address'**
  String get dropoffAddress;

  /// No description provided for @freshFoodTitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh Food'**
  String get freshFoodTitle;

  /// No description provided for @freshFoodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh ingredients, curated daily'**
  String get freshFoodSubtitle;

  /// No description provided for @vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get vegetables;

  /// No description provided for @fruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// No description provided for @meat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get meat;

  /// No description provided for @seafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get seafood;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add some items to get started'**
  String get cartEmptySubtitle;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryFee;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @orderTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orderTitle;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @orderTracking.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get orderTracking;

  /// No description provided for @orderPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderPending;

  /// No description provided for @orderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderConfirmed;

  /// No description provided for @orderPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get orderPreparing;

  /// No description provided for @orderOnWay.
  ///
  /// In en, this message translates to:
  /// **'On the Way'**
  String get orderOnWay;

  /// No description provided for @orderDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderDelivered;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderCancelled;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileUser.
  ///
  /// In en, this message translates to:
  /// **'Aretee User'**
  String get profileUser;

  /// No description provided for @addressSection.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get addressSection;

  /// No description provided for @paymentSection.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentSection;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSection;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @generalSection.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalSection;

  /// No description provided for @helpSection.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpSection;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutSection;

  /// No description provided for @logoutSection.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutSection;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageThai.
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get languageThai;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @orderEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Orders Yet'**
  String get orderEmpty;

  /// No description provided for @orderEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start ordering food or products'**
  String get orderEmptySubtitle;

  /// No description provided for @orderCardTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderCardTotal;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @checkoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get checkoutDialogTitle;

  /// No description provided for @checkoutDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to place this order?'**
  String get checkoutDialogContent;

  /// No description provided for @checkoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully!'**
  String get checkoutSuccess;

  /// No description provided for @foodSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search food...'**
  String get foodSearchHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
