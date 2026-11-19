// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i27;
import 'package:collection/collection.dart' as _i31;
import 'package:flutter/cupertino.dart' as _i32;
import 'package:flutter/foundation.dart' as _i29;
import 'package:flutter/material.dart' as _i28;
import 'package:new_kitap_chesmesi/features/auth/domain/model/register_model.dart'
    as _i33;
import 'package:new_kitap_chesmesi/features/auth/presentation/page/forgot_password_page.dart'
    as _i10;
import 'package:new_kitap_chesmesi/features/auth/presentation/page/login_page.dart'
    as _i11;
import 'package:new_kitap_chesmesi/features/auth/presentation/page/new_password_page.dart'
    as _i13;
import 'package:new_kitap_chesmesi/features/auth/presentation/page/otp_page.dart'
    as _i18;
import 'package:new_kitap_chesmesi/features/auth/presentation/page/register_page.dart'
    as _i20;
import 'package:new_kitap_chesmesi/features/book/presentation/page/add_comment_page.dart'
    as _i2;
import 'package:new_kitap_chesmesi/features/book/presentation/page/all_comments_page.dart'
    as _i3;
import 'package:new_kitap_chesmesi/features/book/presentation/page/book_detail.dart'
    as _i4;
import 'package:new_kitap_chesmesi/features/book/presentation/page/books_page.dart'
    as _i5;
import 'package:new_kitap_chesmesi/features/category/presentation/page/subcategory_page.dart'
    as _i23;
import 'package:new_kitap_chesmesi/features/home/presentation/page/notification_page.dart'
    as _i14;
import 'package:new_kitap_chesmesi/features/navBar/custom_nav_bar.dart' as _i8;
import 'package:new_kitap_chesmesi/features/onboarding/presentation/page/onboarding_category_page.dart'
    as _i15;
import 'package:new_kitap_chesmesi/features/order/domain/model/cart_model.dart'
    as _i30;
import 'package:new_kitap_chesmesi/features/order/presentation/page/etrap_page.dart'
    as _i9;
import 'package:new_kitap_chesmesi/features/order/presentation/page/my_orders_page.dart'
    as _i12;
import 'package:new_kitap_chesmesi/features/order/presentation/page/order_detail_page.dart'
    as _i16;
import 'package:new_kitap_chesmesi/features/order/presentation/page/order_page.dart'
    as _i17;
import 'package:new_kitap_chesmesi/features/order/presentation/page/welayat_page.dart'
    as _i26;
import 'package:new_kitap_chesmesi/features/profile/presentation/page/about_us_page.dart'
    as _i1;
import 'package:new_kitap_chesmesi/features/profile/presentation/page/contact_page.dart'
    as _i6;
import 'package:new_kitap_chesmesi/features/profile/presentation/page/coupon_page.dart'
    as _i7;
import 'package:new_kitap_chesmesi/features/profile/presentation/page/privacy_policy_page.dart'
    as _i19;
import 'package:new_kitap_chesmesi/features/profile/presentation/page/terms_of_use_page.dart'
    as _i24;
import 'package:new_kitap_chesmesi/features/profile/presentation/page/user_edit_page.dart'
    as _i25;
import 'package:new_kitap_chesmesi/features/search/presentation/page/search_page.dart'
    as _i21;
import 'package:new_kitap_chesmesi/features/splash/presentation/page/splash_page.dart'
    as _i22;

/// generated route for
/// [_i1.AboutUsPage]
class AboutUsRoute extends _i27.PageRouteInfo<void> {
  const AboutUsRoute({List<_i27.PageRouteInfo>? children})
      : super(AboutUsRoute.name, initialChildren: children);

  static const String name = 'AboutUsRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutUsPage();
    },
  );
}

/// generated route for
/// [_i2.AddCommentPage]
class AddCommentRoute extends _i27.PageRouteInfo<AddCommentRouteArgs> {
  AddCommentRoute({
    _i28.Key? key,
    required int bookId,
    required String bookTitle,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          AddCommentRoute.name,
          args: AddCommentRouteArgs(
            key: key,
            bookId: bookId,
            bookTitle: bookTitle,
          ),
          initialChildren: children,
        );

  static const String name = 'AddCommentRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddCommentRouteArgs>();
      return _i2.AddCommentPage(
        key: args.key,
        bookId: args.bookId,
        bookTitle: args.bookTitle,
      );
    },
  );
}

class AddCommentRouteArgs {
  const AddCommentRouteArgs({
    this.key,
    required this.bookId,
    required this.bookTitle,
  });

  final _i28.Key? key;

  final int bookId;

  final String bookTitle;

  @override
  String toString() {
    return 'AddCommentRouteArgs{key: $key, bookId: $bookId, bookTitle: $bookTitle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddCommentRouteArgs) return false;
    return key == other.key &&
        bookId == other.bookId &&
        bookTitle == other.bookTitle;
  }

  @override
  int get hashCode => key.hashCode ^ bookId.hashCode ^ bookTitle.hashCode;
}

/// generated route for
/// [_i3.AllCommentsPage]
class AllCommentsRoute extends _i27.PageRouteInfo<AllCommentsRouteArgs> {
  AllCommentsRoute({
    _i28.Key? key,
    required int bookId,
    required String bookTitle,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          AllCommentsRoute.name,
          args: AllCommentsRouteArgs(
            key: key,
            bookId: bookId,
            bookTitle: bookTitle,
          ),
          initialChildren: children,
        );

  static const String name = 'AllCommentsRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AllCommentsRouteArgs>();
      return _i3.AllCommentsPage(
        key: args.key,
        bookId: args.bookId,
        bookTitle: args.bookTitle,
      );
    },
  );
}

class AllCommentsRouteArgs {
  const AllCommentsRouteArgs({
    this.key,
    required this.bookId,
    required this.bookTitle,
  });

  final _i28.Key? key;

  final int bookId;

  final String bookTitle;

  @override
  String toString() {
    return 'AllCommentsRouteArgs{key: $key, bookId: $bookId, bookTitle: $bookTitle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AllCommentsRouteArgs) return false;
    return key == other.key &&
        bookId == other.bookId &&
        bookTitle == other.bookTitle;
  }

  @override
  int get hashCode => key.hashCode ^ bookId.hashCode ^ bookTitle.hashCode;
}

/// generated route for
/// [_i4.BookDetail]
class BookDetailRoute extends _i27.PageRouteInfo<BookDetailRouteArgs> {
  BookDetailRoute({
    _i28.Key? key,
    required int id,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          BookDetailRoute.name,
          args: BookDetailRouteArgs(key: key, id: id),
          initialChildren: children,
        );

  static const String name = 'BookDetailRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookDetailRouteArgs>();
      return _i4.BookDetail(key: args.key, id: args.id);
    },
  );
}

class BookDetailRouteArgs {
  const BookDetailRouteArgs({this.key, required this.id});

  final _i28.Key? key;

  final int id;

  @override
  String toString() {
    return 'BookDetailRouteArgs{key: $key, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BookDetailRouteArgs) return false;
    return key == other.key && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode;
}

/// generated route for
/// [_i5.BooksPage]
class BooksRoute extends _i27.PageRouteInfo<BooksRouteArgs> {
  BooksRoute({
    _i28.Key? key,
    int? subcategoryId,
    required String name,
    required _i5.BookCategoryType categoryType,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          BooksRoute.name,
          args: BooksRouteArgs(
            key: key,
            subcategoryId: subcategoryId,
            name: name,
            categoryType: categoryType,
          ),
          initialChildren: children,
        );

  static const String name = 'BooksRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BooksRouteArgs>();
      return _i5.BooksPage(
        key: args.key,
        subcategoryId: args.subcategoryId,
        name: args.name,
        categoryType: args.categoryType,
      );
    },
  );
}

class BooksRouteArgs {
  const BooksRouteArgs({
    this.key,
    this.subcategoryId,
    required this.name,
    required this.categoryType,
  });

  final _i28.Key? key;

  final int? subcategoryId;

  final String name;

  final _i5.BookCategoryType categoryType;

  @override
  String toString() {
    return 'BooksRouteArgs{key: $key, subcategoryId: $subcategoryId, name: $name, categoryType: $categoryType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BooksRouteArgs) return false;
    return key == other.key &&
        subcategoryId == other.subcategoryId &&
        name == other.name &&
        categoryType == other.categoryType;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      subcategoryId.hashCode ^
      name.hashCode ^
      categoryType.hashCode;
}

/// generated route for
/// [_i6.ContactPage]
class ContactRoute extends _i27.PageRouteInfo<void> {
  const ContactRoute({List<_i27.PageRouteInfo>? children})
      : super(ContactRoute.name, initialChildren: children);

  static const String name = 'ContactRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i6.ContactPage();
    },
  );
}

/// generated route for
/// [_i7.CouponPage]
class CouponRoute extends _i27.PageRouteInfo<void> {
  const CouponRoute({List<_i27.PageRouteInfo>? children})
      : super(CouponRoute.name, initialChildren: children);

  static const String name = 'CouponRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i7.CouponPage();
    },
  );
}

/// generated route for
/// [_i8.CustomNavBar]
class CustomNavBarRoute extends _i27.PageRouteInfo<void> {
  const CustomNavBarRoute({List<_i27.PageRouteInfo>? children})
      : super(CustomNavBarRoute.name, initialChildren: children);

  static const String name = 'CustomNavBarRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i8.CustomNavBar();
    },
  );
}

/// generated route for
/// [_i9.EtrapPage]
class EtrapRoute extends _i27.PageRouteInfo<EtrapRouteArgs> {
  EtrapRoute({
    _i28.Key? key,
    required int welayatId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          EtrapRoute.name,
          args: EtrapRouteArgs(key: key, welayatId: welayatId),
          initialChildren: children,
        );

  static const String name = 'EtrapRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EtrapRouteArgs>();
      return _i9.EtrapPage(key: args.key, welayatId: args.welayatId);
    },
  );
}

class EtrapRouteArgs {
  const EtrapRouteArgs({this.key, required this.welayatId});

  final _i28.Key? key;

  final int welayatId;

  @override
  String toString() {
    return 'EtrapRouteArgs{key: $key, welayatId: $welayatId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EtrapRouteArgs) return false;
    return key == other.key && welayatId == other.welayatId;
  }

  @override
  int get hashCode => key.hashCode ^ welayatId.hashCode;
}

/// generated route for
/// [_i10.ForgotPasswordPage]
class ForgotPasswordRoute extends _i27.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i27.PageRouteInfo>? children})
      : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i10.ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [_i11.LoginPage]
class LoginRoute extends _i27.PageRouteInfo<void> {
  const LoginRoute({List<_i27.PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i11.LoginPage();
    },
  );
}

/// generated route for
/// [_i12.MyOrdersPage]
class MyOrdersRoute extends _i27.PageRouteInfo<void> {
  const MyOrdersRoute({List<_i27.PageRouteInfo>? children})
      : super(MyOrdersRoute.name, initialChildren: children);

  static const String name = 'MyOrdersRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i12.MyOrdersPage();
    },
  );
}

/// generated route for
/// [_i13.NewPasswordPage]
class NewPasswordRoute extends _i27.PageRouteInfo<NewPasswordRouteArgs> {
  NewPasswordRoute({
    _i28.Key? key,
    required String phoneNumber,
    required String code,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          NewPasswordRoute.name,
          args: NewPasswordRouteArgs(
            key: key,
            phoneNumber: phoneNumber,
            code: code,
          ),
          initialChildren: children,
        );

  static const String name = 'NewPasswordRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NewPasswordRouteArgs>();
      return _i13.NewPasswordPage(
        key: args.key,
        phoneNumber: args.phoneNumber,
        code: args.code,
      );
    },
  );
}

class NewPasswordRouteArgs {
  const NewPasswordRouteArgs({
    this.key,
    required this.phoneNumber,
    required this.code,
  });

  final _i28.Key? key;

  final String phoneNumber;

  final String code;

  @override
  String toString() {
    return 'NewPasswordRouteArgs{key: $key, phoneNumber: $phoneNumber, code: $code}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NewPasswordRouteArgs) return false;
    return key == other.key &&
        phoneNumber == other.phoneNumber &&
        code == other.code;
  }

  @override
  int get hashCode => key.hashCode ^ phoneNumber.hashCode ^ code.hashCode;
}

/// generated route for
/// [_i14.NotificationPage]
class NotificationRoute extends _i27.PageRouteInfo<void> {
  const NotificationRoute({List<_i27.PageRouteInfo>? children})
      : super(NotificationRoute.name, initialChildren: children);

  static const String name = 'NotificationRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i14.NotificationPage();
    },
  );
}

/// generated route for
/// [_i15.OnboardingCategoryPage]
class OnboardingCategoryRoute extends _i27.PageRouteInfo<void> {
  const OnboardingCategoryRoute({List<_i27.PageRouteInfo>? children})
      : super(OnboardingCategoryRoute.name, initialChildren: children);

  static const String name = 'OnboardingCategoryRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i15.OnboardingCategoryPage();
    },
  );
}

/// generated route for
/// [_i16.OrderDetailPage]
class OrderDetailRoute extends _i27.PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    _i29.Key? key,
    required int orderId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          OrderDetailRoute.name,
          args: OrderDetailRouteArgs(key: key, orderId: orderId),
          initialChildren: children,
        );

  static const String name = 'OrderDetailRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailRouteArgs>();
      return _i16.OrderDetailPage(key: args.key, orderId: args.orderId);
    },
  );
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({this.key, required this.orderId});

  final _i29.Key? key;

  final int orderId;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, orderId: $orderId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderDetailRouteArgs) return false;
    return key == other.key && orderId == other.orderId;
  }

  @override
  int get hashCode => key.hashCode ^ orderId.hashCode;
}

/// generated route for
/// [_i17.OrderPage]
class OrderRoute extends _i27.PageRouteInfo<OrderRouteArgs> {
  OrderRoute({
    _i28.Key? key,
    required List<_i30.CartItemModel> cartItems,
    required double totalPrice,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          OrderRoute.name,
          args: OrderRouteArgs(
            key: key,
            cartItems: cartItems,
            totalPrice: totalPrice,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderRouteArgs>();
      return _i17.OrderPage(
        key: args.key,
        cartItems: args.cartItems,
        totalPrice: args.totalPrice,
      );
    },
  );
}

class OrderRouteArgs {
  const OrderRouteArgs({
    this.key,
    required this.cartItems,
    required this.totalPrice,
  });

  final _i28.Key? key;

  final List<_i30.CartItemModel> cartItems;

  final double totalPrice;

  @override
  String toString() {
    return 'OrderRouteArgs{key: $key, cartItems: $cartItems, totalPrice: $totalPrice}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderRouteArgs) return false;
    return key == other.key &&
        const _i31.ListEquality<_i30.CartItemModel>().equals(
          cartItems,
          other.cartItems,
        ) &&
        totalPrice == other.totalPrice;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      const _i31.ListEquality<_i30.CartItemModel>().hash(cartItems) ^
      totalPrice.hashCode;
}

/// generated route for
/// [_i18.OtpPage]
class OtpRoute extends _i27.PageRouteInfo<OtpRouteArgs> {
  OtpRoute({
    _i28.Key? key,
    required String type,
    String? name,
    String? surname,
    String? password,
    required String phoneNumber,
    String? birthday,
    String? referralCode,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          OtpRoute.name,
          args: OtpRouteArgs(
            key: key,
            type: type,
            name: name,
            surname: surname,
            password: password,
            phoneNumber: phoneNumber,
            birthday: birthday,
            referralCode: referralCode,
          ),
          initialChildren: children,
        );

  static const String name = 'OtpRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OtpRouteArgs>();
      return _i18.OtpPage(
        key: args.key,
        type: args.type,
        name: args.name,
        surname: args.surname,
        password: args.password,
        phoneNumber: args.phoneNumber,
        birthday: args.birthday,
        referralCode: args.referralCode,
      );
    },
  );
}

class OtpRouteArgs {
  const OtpRouteArgs({
    this.key,
    required this.type,
    this.name,
    this.surname,
    this.password,
    required this.phoneNumber,
    this.birthday,
    this.referralCode,
  });

  final _i28.Key? key;

  final String type;

  final String? name;

  final String? surname;

  final String? password;

  final String phoneNumber;

  final String? birthday;

  final String? referralCode;

  @override
  String toString() {
    return 'OtpRouteArgs{key: $key, type: $type, name: $name, surname: $surname, password: $password, phoneNumber: $phoneNumber, birthday: $birthday, referralCode: $referralCode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OtpRouteArgs) return false;
    return key == other.key &&
        type == other.type &&
        name == other.name &&
        surname == other.surname &&
        password == other.password &&
        phoneNumber == other.phoneNumber &&
        birthday == other.birthday &&
        referralCode == other.referralCode;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      type.hashCode ^
      name.hashCode ^
      surname.hashCode ^
      password.hashCode ^
      phoneNumber.hashCode ^
      birthday.hashCode ^
      referralCode.hashCode;
}

/// generated route for
/// [_i19.PrivacyPolicyPage]
class PrivacyPolicyRoute extends _i27.PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<_i27.PageRouteInfo>? children})
      : super(PrivacyPolicyRoute.name, initialChildren: children);

  static const String name = 'PrivacyPolicyRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i19.PrivacyPolicyPage();
    },
  );
}

/// generated route for
/// [_i20.RegisterPage]
class RegisterRoute extends _i27.PageRouteInfo<void> {
  const RegisterRoute({List<_i27.PageRouteInfo>? children})
      : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i20.RegisterPage();
    },
  );
}

/// generated route for
/// [_i21.SearchPage]
class SearchRoute extends _i27.PageRouteInfo<void> {
  const SearchRoute({List<_i27.PageRouteInfo>? children})
      : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i21.SearchPage();
    },
  );
}

/// generated route for
/// [_i22.SplashPage]
class SplashRoute extends _i27.PageRouteInfo<void> {
  const SplashRoute({List<_i27.PageRouteInfo>? children})
      : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i22.SplashPage();
    },
  );
}

/// generated route for
/// [_i23.SubcategoryPage]
class SubcategoryRoute extends _i27.PageRouteInfo<SubcategoryRouteArgs> {
  SubcategoryRoute({
    _i28.Key? key,
    required String id,
    required String title,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          SubcategoryRoute.name,
          args: SubcategoryRouteArgs(key: key, id: id, title: title),
          initialChildren: children,
        );

  static const String name = 'SubcategoryRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SubcategoryRouteArgs>();
      return _i23.SubcategoryPage(
        key: args.key,
        id: args.id,
        title: args.title,
      );
    },
  );
}

class SubcategoryRouteArgs {
  const SubcategoryRouteArgs({this.key, required this.id, required this.title});

  final _i28.Key? key;

  final String id;

  final String title;

  @override
  String toString() {
    return 'SubcategoryRouteArgs{key: $key, id: $id, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SubcategoryRouteArgs) return false;
    return key == other.key && id == other.id && title == other.title;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode ^ title.hashCode;
}

/// generated route for
/// [_i24.TermsOfUsePage]
class TermsOfUseRoute extends _i27.PageRouteInfo<void> {
  const TermsOfUseRoute({List<_i27.PageRouteInfo>? children})
      : super(TermsOfUseRoute.name, initialChildren: children);

  static const String name = 'TermsOfUseRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i24.TermsOfUsePage();
    },
  );
}

/// generated route for
/// [_i25.UserEditPage]
class UserEditRoute extends _i27.PageRouteInfo<UserEditRouteArgs> {
  UserEditRoute({
    _i32.Key? key,
    _i33.UserDetailModel? user,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          UserEditRoute.name,
          args: UserEditRouteArgs(key: key, user: user),
          initialChildren: children,
        );

  static const String name = 'UserEditRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserEditRouteArgs>(
        orElse: () => const UserEditRouteArgs(),
      );
      return _i25.UserEditPage(key: args.key, user: args.user);
    },
  );
}

class UserEditRouteArgs {
  const UserEditRouteArgs({this.key, this.user});

  final _i32.Key? key;

  final _i33.UserDetailModel? user;

  @override
  String toString() {
    return 'UserEditRouteArgs{key: $key, user: $user}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserEditRouteArgs) return false;
    return key == other.key && user == other.user;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode;
}

/// generated route for
/// [_i26.WelayatPage]
class WelayatRoute extends _i27.PageRouteInfo<void> {
  const WelayatRoute({List<_i27.PageRouteInfo>? children})
      : super(WelayatRoute.name, initialChildren: children);

  static const String name = 'WelayatRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i26.WelayatPage();
    },
  );
}
