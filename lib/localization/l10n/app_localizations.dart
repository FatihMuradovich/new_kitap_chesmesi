import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

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
    Locale('ru'),
    Locale('tr')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Book Shop'**
  String get title;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @noInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetTitle;

  /// No description provided for @noInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get noInternetMessage;

  /// No description provided for @homeScreen.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeScreen;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @profil.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profil;

  /// No description provided for @newBooks.
  ///
  /// In en, this message translates to:
  /// **'New Books'**
  String get newBooks;

  /// No description provided for @discountBook.
  ///
  /// In en, this message translates to:
  /// **'Discounted Books'**
  String get discountBook;

  /// No description provided for @turkmenBooks.
  ///
  /// In en, this message translates to:
  /// **'Turkmen Books'**
  String get turkmenBooks;

  /// No description provided for @childrenBooks.
  ///
  /// In en, this message translates to:
  /// **'Children\'s Books'**
  String get childrenBooks;

  /// No description provided for @bookAuthorSearch.
  ///
  /// In en, this message translates to:
  /// **'Book, author...'**
  String get bookAuthorSearch;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notification;

  /// No description provided for @searchPage.
  ///
  /// In en, this message translates to:
  /// **'Search page'**
  String get searchPage;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'Book not found!'**
  String get noResultsFound;

  /// No description provided for @errorMessageSearch.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while searching!'**
  String get errorMessageSearch;

  /// No description provided for @viewing.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get viewing;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @auhtorsOtherBook.
  ///
  /// In en, this message translates to:
  /// **'Other books by author'**
  String get auhtorsOtherBook;

  /// No description provided for @productCode.
  ///
  /// In en, this message translates to:
  /// **'Product code'**
  String get productCode;

  /// No description provided for @publisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get publisher;

  /// No description provided for @bookLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get bookLanguage;

  /// No description provided for @bookCover.
  ///
  /// In en, this message translates to:
  /// **'Book cover'**
  String get bookCover;

  /// No description provided for @publishYear.
  ///
  /// In en, this message translates to:
  /// **'Publication year'**
  String get publishYear;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get page;

  /// No description provided for @hardCover.
  ///
  /// In en, this message translates to:
  /// **'Hardcover'**
  String get hardCover;

  /// No description provided for @softCover.
  ///
  /// In en, this message translates to:
  /// **'Softcover'**
  String get softCover;

  /// No description provided for @add_cart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get add_cart;

  /// No description provided for @ratingsAndComments.
  ///
  /// In en, this message translates to:
  /// **'Ratings and comments'**
  String get ratingsAndComments;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add comment...'**
  String get addComment;

  /// No description provided for @commentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any ratings and comments yet'**
  String get commentsEmpty;

  /// No description provided for @commentsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Please add the first rating and comment for this book!'**
  String get commentsEmptyHint;

  /// No description provided for @commentsError.
  ///
  /// In en, this message translates to:
  /// **'Ratings and comments could not be loaded'**
  String get commentsError;

  /// No description provided for @commentsErrorHint.
  ///
  /// In en, this message translates to:
  /// **'Ratings and comments could not be loaded'**
  String get commentsErrorHint;

  /// No description provided for @commentAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your comment has been sended successfully!'**
  String get commentAddedSuccessfully;

  /// No description provided for @clearRating.
  ///
  /// In en, this message translates to:
  /// **'Clear rating'**
  String get clearRating;

  /// No description provided for @ratingNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Rating not selected'**
  String get ratingNotSelected;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Write your comment!'**
  String get commentHint;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Your comment...'**
  String get comment;

  /// No description provided for @sendComment.
  ///
  /// In en, this message translates to:
  /// **'Send comment'**
  String get sendComment;

  /// No description provided for @commentInfo.
  ///
  /// In en, this message translates to:
  /// **'Your comment will be moderated and displayed.'**
  String get commentInfo;

  /// No description provided for @commentInfoHint.
  ///
  /// In en, this message translates to:
  /// **'Please don\'t forget to write your comment.'**
  String get commentInfoHint;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'rating'**
  String get rating;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'stars'**
  String get stars;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'day ago'**
  String get daysAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'hour ago'**
  String get hoursAgo;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'minute ago'**
  String get minutesAgo;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @writeFirstComment.
  ///
  /// In en, this message translates to:
  /// **'Write the first review for this book!'**
  String get writeFirstComment;

  /// No description provided for @cartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartIsEmpty;

  /// No description provided for @empty_basket.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get empty_basket;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get totalAmount;

  /// No description provided for @acceptCart.
  ///
  /// In en, this message translates to:
  /// **'Confirm cart'**
  String get acceptCart;

  /// No description provided for @completeOrder.
  ///
  /// In en, this message translates to:
  /// **'Complete order'**
  String get completeOrder;

  /// No description provided for @yourAdress.
  ///
  /// In en, this message translates to:
  /// **'Your address (Street, house, apartment...)'**
  String get yourAdress;

  /// No description provided for @addressIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address!'**
  String get addressIsRequired;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @priceOfBooks.
  ///
  /// In en, this message translates to:
  /// **'Price of books:'**
  String get priceOfBooks;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal:'**
  String get subtotal;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery fee:'**
  String get deliveryFee;

  /// No description provided for @giftPaperFee.
  ///
  /// In en, this message translates to:
  /// **'Gift paper fee:'**
  String get giftPaperFee;

  /// No description provided for @giftError.
  ///
  /// In en, this message translates to:
  /// **'Error loading gift covers!'**
  String get giftError;

  /// No description provided for @orderSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your order has been successfully completed!'**
  String get orderSuccess;

  /// No description provided for @orderSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Your order was successfully received'**
  String get orderSuccessTitle;

  /// No description provided for @orderSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order has been successfully received. We will contact you soon!'**
  String get orderSuccessMessage;

  /// No description provided for @goIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get goIt;

  /// No description provided for @confirmRemoveFromCart.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove this book from your cart?'**
  String get confirmRemoveFromCart;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @giftPaper.
  ///
  /// In en, this message translates to:
  /// **'Gift paper covers'**
  String get giftPaper;

  /// No description provided for @chooseProvince.
  ///
  /// In en, this message translates to:
  /// **'Choose province'**
  String get chooseProvince;

  /// No description provided for @chooseDistrict.
  ///
  /// In en, this message translates to:
  /// **'Choose district'**
  String get chooseDistrict;

  /// No description provided for @selectFirstProvince.
  ///
  /// In en, this message translates to:
  /// **'Select first province'**
  String get selectFirstProvince;

  /// No description provided for @noDistrictFound.
  ///
  /// In en, this message translates to:
  /// **'Districts not found!'**
  String get noDistrictFound;

  /// No description provided for @noProvinceFound.
  ///
  /// In en, this message translates to:
  /// **'Province not found!'**
  String get noProvinceFound;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock!'**
  String get outOfStock;

  /// No description provided for @stockIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Stock is empty!'**
  String get stockIsEmpty;

  /// No description provided for @productAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Product successfully added to cart!'**
  String get productAddedToCart;

  /// No description provided for @enterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the coupon code!'**
  String get enterCouponCode;

  /// No description provided for @couponDiscount.
  ///
  /// In en, this message translates to:
  /// **'Coupon savings'**
  String get couponDiscount;

  /// No description provided for @couponUsed.
  ///
  /// In en, this message translates to:
  /// **'Coupon successfully applied!'**
  String get couponUsed;

  /// No description provided for @use.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get use;

  /// No description provided for @orderLoading.
  ///
  /// In en, this message translates to:
  /// **'Order is being processed...'**
  String get orderLoading;

  /// No description provided for @favoriteIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your favorite is empty!'**
  String get favoriteIsEmpty;

  /// No description provided for @empty_favorites.
  ///
  /// In en, this message translates to:
  /// **'Your favorites list is empty!'**
  String get empty_favorites;

  /// No description provided for @allBooks.
  ///
  /// In en, this message translates to:
  /// **'All Books'**
  String get allBooks;

  /// No description provided for @emptyCategory.
  ///
  /// In en, this message translates to:
  /// **'There are no books in this category!'**
  String get emptyCategory;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get myOrders;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'You have no orders yet'**
  String get noOrdersYet;

  /// No description provided for @orderItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} books'**
  String orderItemsCount(int count);

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @activeOrder.
  ///
  /// In en, this message translates to:
  /// **'Active Order'**
  String get activeOrder;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @orderReceived.
  ///
  /// In en, this message translates to:
  /// **'Order received'**
  String get orderReceived;

  /// No description provided for @orderDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get orderDetailTitle;

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'Books in the order'**
  String get orderItems;

  /// No description provided for @orderStatusHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order status history'**
  String get orderStatusHistoryTitle;

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderTotal;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get deliveryAddress;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelOrder;

  /// No description provided for @cancelOrderConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel the order?'**
  String get cancelOrderConfirmTitle;

  /// No description provided for @cancelOrderConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This order will be cancelled. This action cannot be undone.'**
  String get cancelOrderConfirmMessage;

  /// No description provided for @cancelReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Reason for cancellation (optional)'**
  String get cancelReasonHint;

  /// No description provided for @orderCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your order has been cancelled'**
  String get orderCancelledSuccess;

  /// No description provided for @orderCannotBeCancelled.
  ///
  /// In en, this message translates to:
  /// **'This order can no longer be cancelled. Please contact us.'**
  String get orderCannotBeCancelled;

  /// No description provided for @orderNotFound.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get orderNotFound;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @orderActorUser.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get orderActorUser;

  /// No description provided for @orderActorAdmin.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get orderActorAdmin;

  /// No description provided for @orderActorSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get orderActorSystem;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get rules;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutDescription.
  ///
  /// In en, this message translates to:
  /// **'Do you want to sign out?'**
  String get signOutDescription;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **''**
  String get areYouSure;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone!'**
  String get deleteAccountDescription;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personal_information;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @your_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get your_phone_number;

  /// No description provided for @your_email_adress.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get your_email_adress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @old_password.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get old_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your profile has been updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @coupon.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get coupon;

  /// No description provided for @get_coupon.
  ///
  /// In en, this message translates to:
  /// **'Invite your friends and receive a 5% discount coupon'**
  String get get_coupon;

  /// No description provided for @youDonHaveAnyCoupons.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any coupons yet'**
  String get youDonHaveAnyCoupons;

  /// No description provided for @earnCoupon.
  ///
  /// In en, this message translates to:
  /// **'You can earn coupons by inviting your friends!'**
  String get earnCoupon;

  /// No description provided for @couponError.
  ///
  /// In en, this message translates to:
  /// **'Coupons could not be loaded'**
  String get couponError;

  /// No description provided for @invalidCoupon.
  ///
  /// In en, this message translates to:
  /// **'Invalid coupon code!'**
  String get invalidCoupon;

  /// No description provided for @couponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon code'**
  String get couponCode;

  /// No description provided for @discountRate.
  ///
  /// In en, this message translates to:
  /// **'Discount rate'**
  String get discountRate;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @passive.
  ///
  /// In en, this message translates to:
  /// **'Passive'**
  String get passive;

  /// No description provided for @couponTypeHoliday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get couponTypeHoliday;

  /// No description provided for @couponTypeBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get couponTypeBirthday;

  /// No description provided for @couponTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get couponTypeOther;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created date:'**
  String get created;

  /// No description provided for @couponCopied.
  ///
  /// In en, this message translates to:
  /// **'Coupon code copied!'**
  String get couponCopied;

  /// No description provided for @couponNotAllowedWithBookDiscount.
  ///
  /// In en, this message translates to:
  /// **'Coupons cannot be used for books that are on sale.'**
  String get couponNotAllowedWithBookDiscount;

  /// No description provided for @contact_information.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contact_information;

  /// No description provided for @our_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get our_phone_number;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email_address;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @tiktok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get tiktok;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendMessage;

  /// No description provided for @messageSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your message has been sent successfully!'**
  String get messageSentSuccessfully;

  /// No description provided for @messageCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Message cannot be empty!'**
  String get messageCannotBeEmpty;

  /// No description provided for @contactHint.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or suggestions, please write to us!'**
  String get contactHint;

  /// No description provided for @contactResponse.
  ///
  /// In en, this message translates to:
  /// **'We will answer your message as soon as possible after receiving your message.'**
  String get contactResponse;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect phone number or password'**
  String get invalidCredentials;

  /// No description provided for @stockLimit.
  ///
  /// In en, this message translates to:
  /// **'Not enough stock. You can add at most {count}.'**
  String stockLimit(int count);

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred!'**
  String get errorMessage;

  /// No description provided for @notificationIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications!'**
  String get notificationIsEmpty;

  /// No description provided for @notificationIsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'No notifications for now'**
  String get notificationIsEmptyDescription;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout?'**
  String get logout;

  /// No description provided for @registerOderSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account'**
  String get registerOderSignUp;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get register;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @emptyFieldError.
  ///
  /// In en, this message translates to:
  /// **'Field cannot be empty!'**
  String get emptyFieldError;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted successfully!'**
  String get accountDeletedSuccessfully;

  /// No description provided for @phoneNumberCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot be empty!'**
  String get phoneNumberCannotBeEmpty;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number!'**
  String get invalidPhoneNumber;

  /// No description provided for @imageNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Upload failed!'**
  String get imageNotLoaded;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @youDontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have an account?'**
  String get youDontHaveAnAccount;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @passwordHintHint.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordHintHint;

  /// No description provided for @doYouHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Do you have an account?'**
  String get doYouHaveAccount;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral code'**
  String get referralCode;

  /// No description provided for @birthdayHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your birthday'**
  String get birthdayHint;

  /// No description provided for @continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_button;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get forgotPasswordDescription;

  /// No description provided for @forgotPasswordDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'We will send a 6-digit verification code to your phone number.'**
  String get forgotPasswordDescriptionHint;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get sendVerificationCode;

  /// No description provided for @newCodeSent.
  ///
  /// In en, this message translates to:
  /// **'A new code has been sent.'**
  String get newCodeSent;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @dontReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Don\'t receive the code?'**
  String get dontReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get newPasswordHint;

  /// No description provided for @newPasswordHintHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong and memorable password'**
  String get newPasswordHintHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match!'**
  String get confirmPasswordHint;

  /// No description provided for @invalidCodeEntered.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code entered.'**
  String get invalidCodeEntered;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'(Optional)'**
  String get optional;

  /// No description provided for @referralCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Use your friend\'s referral code and both of you will get a 5% discount coupon!'**
  String get referralCodeHint;

  /// No description provided for @referralCodeHintHint.
  ///
  /// In en, this message translates to:
  /// **'Referral code must be 6 characters long!'**
  String get referralCodeHintHint;

  /// No description provided for @selectCategories.
  ///
  /// In en, this message translates to:
  /// **'Select your favorite categories!'**
  String get selectCategories;

  /// No description provided for @selectCategoriesHint.
  ///
  /// In en, this message translates to:
  /// **'Select at least 3 categories to receive personalized recommendations.'**
  String get selectCategoriesHint;

  /// No description provided for @selectCategoriesButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get selectCategoriesButton;

  /// No description provided for @categoriesNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Categories not loaded.'**
  String get categoriesNotLoaded;

  /// No description provided for @categoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Category not found.'**
  String get categoryNotFound;

  /// No description provided for @recommendedBooks.
  ///
  /// In en, this message translates to:
  /// **'Recommended books'**
  String get recommendedBooks;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailable;

  /// No description provided for @updateAvailableHint.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is available. Update now to enjoy new features, improvements, and bug fixes.'**
  String get updateAvailableHint;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateNow;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get priceRange;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @priceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price ascending'**
  String get priceAsc;

  /// No description provided for @priceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price descending'**
  String get priceDesc;

  /// No description provided for @mostPurchased.
  ///
  /// In en, this message translates to:
  /// **'Most purchased'**
  String get mostPurchased;

  /// No description provided for @authorSearch.
  ///
  /// In en, this message translates to:
  /// **'Author search...'**
  String get authorSearch;

  /// No description provided for @authorsSelected.
  ///
  /// In en, this message translates to:
  /// **'authors selected'**
  String get authorsSelected;

  /// No description provided for @authorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Author not found'**
  String get authorNotFound;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @publisherSearch.
  ///
  /// In en, this message translates to:
  /// **'Publisher search...'**
  String get publisherSearch;

  /// No description provided for @publishersSelected.
  ///
  /// In en, this message translates to:
  /// **'publishers selected'**
  String get publishersSelected;

  /// No description provided for @publisherNotFound.
  ///
  /// In en, this message translates to:
  /// **'Publisher not found'**
  String get publisherNotFound;

  /// No description provided for @languagesSelected.
  ///
  /// In en, this message translates to:
  /// **'languages selected'**
  String get languagesSelected;

  /// No description provided for @minPrice.
  ///
  /// In en, this message translates to:
  /// **'Min.'**
  String get minPrice;

  /// No description provided for @maxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max.'**
  String get maxPrice;

  /// No description provided for @priceRangeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the minimum and maximum price'**
  String get priceRangeHint;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @priceOnRequest.
  ///
  /// In en, this message translates to:
  /// **'Price on request'**
  String get priceOnRequest;

  /// No description provided for @specialOrderSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'We can bring it'**
  String get specialOrderSectionTitle;

  /// No description provided for @specialOrderBadge.
  ///
  /// In en, this message translates to:
  /// **'Can be ordered'**
  String get specialOrderBadge;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My requests'**
  String get myRequests;

  /// No description provided for @specialOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Special order'**
  String get specialOrderTitle;

  /// No description provided for @createSpecialOrder.
  ///
  /// In en, this message translates to:
  /// **'Place a special order'**
  String get createSpecialOrder;

  /// No description provided for @specialOrderSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Bring it from abroad'**
  String get specialOrderSheetTitle;

  /// No description provided for @specialOrderSheetInfo.
  ///
  /// In en, this message translates to:
  /// **'Open a request — we will check the price and send you a quote.'**
  String get specialOrderSheetInfo;

  /// No description provided for @specialOrderNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Your note (optional)'**
  String get specialOrderNoteHint;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get sendRequest;

  /// No description provided for @specialOrderRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Your request has been received. We will notify you when the quote is ready.'**
  String get specialOrderRequestSent;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @specialOrderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get specialOrderStatusPending;

  /// No description provided for @specialOrderStatusQuoted.
  ///
  /// In en, this message translates to:
  /// **'Quote ready'**
  String get specialOrderStatusQuoted;

  /// No description provided for @specialOrderStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get specialOrderStatusApproved;

  /// No description provided for @specialOrderStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get specialOrderStatusRejected;

  /// No description provided for @specialOrderStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get specialOrderStatusExpired;

  /// No description provided for @specialOrderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get specialOrderStatusCancelled;

  /// No description provided for @specialOrderStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get specialOrderStatusUnavailable;

  /// No description provided for @supplyStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Supply progress'**
  String get supplyStatusTitle;

  /// No description provided for @supplyStatusPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get supplyStatusPreparing;

  /// No description provided for @supplyStatusOrderedAbroad.
  ///
  /// In en, this message translates to:
  /// **'Ordered abroad'**
  String get supplyStatusOrderedAbroad;

  /// No description provided for @supplyStatusInTransit.
  ///
  /// In en, this message translates to:
  /// **'In transit'**
  String get supplyStatusInTransit;

  /// No description provided for @supplyStatusArrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get supplyStatusArrived;

  /// No description provided for @requestNumber.
  ///
  /// In en, this message translates to:
  /// **'Request #{id}'**
  String requestNumber(int id);

  /// No description provided for @activeRequest.
  ///
  /// In en, this message translates to:
  /// **'Active request'**
  String get activeRequest;

  /// No description provided for @requestHistory.
  ///
  /// In en, this message translates to:
  /// **'Request history'**
  String get requestHistory;

  /// No description provided for @emptyRequests.
  ///
  /// In en, this message translates to:
  /// **'You have no requests'**
  String get emptyRequests;

  /// No description provided for @emptyRequestsHint.
  ///
  /// In en, this message translates to:
  /// **'We can bring books that are out of stock from abroad.'**
  String get emptyRequestsHint;

  /// No description provided for @requestNotFound.
  ///
  /// In en, this message translates to:
  /// **'Request not found'**
  String get requestNotFound;

  /// No description provided for @deliveryMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery method'**
  String get deliveryMethodLabel;

  /// No description provided for @deliveryMethodDays.
  ///
  /// In en, this message translates to:
  /// **'{min}–{max} days'**
  String deliveryMethodDays(int min, int max);

  /// No description provided for @selectDeliveryMethod.
  ///
  /// In en, this message translates to:
  /// **'Select a delivery method'**
  String get selectDeliveryMethod;

  /// No description provided for @selectBooks.
  ///
  /// In en, this message translates to:
  /// **'Select books'**
  String get selectBooks;

  /// No description provided for @itemUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get itemUnavailable;

  /// No description provided for @noPriceForMethod.
  ///
  /// In en, this message translates to:
  /// **'Not available with this method'**
  String get noPriceForMethod;

  /// No description provided for @adminNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Note from the store'**
  String get adminNoteTitle;

  /// No description provided for @quoteExpiresAt.
  ///
  /// In en, this message translates to:
  /// **'Quote valid until: {date}'**
  String quoteExpiresAt(String date);

  /// No description provided for @quoteExpired.
  ///
  /// In en, this message translates to:
  /// **'This quote has expired'**
  String get quoteExpired;

  /// No description provided for @productsTotal.
  ///
  /// In en, this message translates to:
  /// **'Books total'**
  String get productsTotal;

  /// No description provided for @approveQuote.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approveQuote;

  /// No description provided for @rejectQuote.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectQuote;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get cancelRequest;

  /// No description provided for @rejectQuoteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject this quote?'**
  String get rejectQuoteConfirmTitle;

  /// No description provided for @rejectQuoteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This quote will be rejected. This action cannot be undone.'**
  String get rejectQuoteConfirmMessage;

  /// No description provided for @cancelRequestConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this request?'**
  String get cancelRequestConfirmTitle;

  /// No description provided for @cancelRequestConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This request will be cancelled. This action cannot be undone.'**
  String get cancelRequestConfirmMessage;

  /// No description provided for @quoteRejectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Quote rejected'**
  String get quoteRejectedSuccess;

  /// No description provided for @requestCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your request has been cancelled'**
  String get requestCancelledSuccess;

  /// No description provided for @requestActionNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This action is no longer possible.'**
  String get requestActionNotAllowed;

  /// No description provided for @selectAtLeastOneBook.
  ///
  /// In en, this message translates to:
  /// **'Select at least one book'**
  String get selectAtLeastOneBook;

  /// No description provided for @estimatedArrival.
  ///
  /// In en, this message translates to:
  /// **'Estimated arrival'**
  String get estimatedArrival;

  /// No description provided for @specialOrderNoCoupon.
  ///
  /// In en, this message translates to:
  /// **'Coupons cannot be used for special orders'**
  String get specialOrderNoCoupon;

  /// No description provided for @bookAlreadyInOpenRequest.
  ///
  /// In en, this message translates to:
  /// **'This book is already in one of your open requests'**
  String get bookAlreadyInOpenRequest;

  /// No description provided for @bookNotSpecialOrderable.
  ///
  /// In en, this message translates to:
  /// **'This book cannot be ordered specially'**
  String get bookNotSpecialOrderable;

  /// No description provided for @specialOrderCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'The request could not be created. Please try again later.'**
  String get specialOrderCreateFailed;
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
      <String>['en', 'ru', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
