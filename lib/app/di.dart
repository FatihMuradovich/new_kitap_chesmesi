import 'package:get_it/get_it.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/core/config/api_config.dart';
import 'package:new_kitap_chesmesi/core/config/update_config.dart';
import 'package:new_kitap_chesmesi/core/service/language_service.dart';
import 'package:new_kitap_chesmesi/core/service/update_service.dart';
import 'package:new_kitap_chesmesi/features/auth/data/data_source/forgot_password_data_source.dart';
import 'package:new_kitap_chesmesi/features/auth/data/data_source/login_data_source.dart';
import 'package:new_kitap_chesmesi/features/auth/data/data_source/register_code_otp_data_source.dart';
import 'package:new_kitap_chesmesi/features/auth/data/data_source/register_data_source.dart';
import 'package:new_kitap_chesmesi/features/auth/data/repository/forgot_password_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/auth/data/repository/login_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/auth/data/repository/register_code_otp_impl.dart';
import 'package:new_kitap_chesmesi/features/auth/data/repository/register_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/forgot_password_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/login_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/register_code_otp_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/register_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/forgot/forgot_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/register_code/register_code_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/book_publisher_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/book_language_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/book_publisher_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_publisher_repository.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/book_author_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/book_by_author_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/book_language_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/book_author_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_language_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_author_repository.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/book_by_language_id_data_soruce.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/book_detail_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/books_by_category_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/discount_book_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/latest_book_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/comment_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/all_books_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/book_by_author_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/book_by_language_id_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/book_detail_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/books_by_category_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/discounted_book_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/latest_book_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/comment_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/all_books_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_by_author_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_by_language_id_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/book_detail_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/books_by_category_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/discounted_book_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/latest_book_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/comment_repository.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/all_books_repository.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/book/books_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/discounted_book/discounted_book_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/getBookByAuthorId/book_by_author_id_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/getBookById/get_book_by_id_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/latest_book/latest_book_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/comment/comment_cubit.dart';
import 'package:new_kitap_chesmesi/features/category/data/data_source/category_data_source.dart';
import 'package:new_kitap_chesmesi/features/category/data/data_source/subcategory_data_source.dart';
import 'package:new_kitap_chesmesi/features/category/data/repository/category_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/category/data/repository/subcategory_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/category/domain/repository/category_repository.dart';
import 'package:new_kitap_chesmesi/features/category/domain/repository/subcateogry_repository.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/category_cubit.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/cubit/subcategory_cubit.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:new_kitap_chesmesi/features/home/data/data_source/banner_data_source.dart';
import 'package:new_kitap_chesmesi/features/home/data/data_source/home_data_source.dart';
import 'package:new_kitap_chesmesi/features/home/data/data_source/notification_data_source.dart';
import 'package:new_kitap_chesmesi/features/home/data/repository/home_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/home/data/repository/notification_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/home/domain/repository/home_repository.dart';
import 'package:new_kitap_chesmesi/features/home/domain/repository/notification_repository.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/banner/banner_cubit.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/home/home_cubit.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/notification/notification_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/data/data_source/etrap_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/data/data_source/gift_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/data/data_source/order_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/data/data_source/cart_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/data/data_source/welayat_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/data/repository/etrap_repository_iml.dart';
import 'package:new_kitap_chesmesi/features/order/data/repository/gift_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/order/data/repository/order_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/order/data/repository/welayat_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/cart_repository.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/etrap_repository.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/gift_repository.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/order_repository.dart';
import 'package:new_kitap_chesmesi/features/order/data/repository/cart_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/order/domain/repository/welayat_repository.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cart/cart_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/gift/gift_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/my_orders/my_orders_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/order/order_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/order_detail/order_detail_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/welayat_etrap/cubit/welayatAndEtrap_cubit.dart';
// import 'package:new_kitap_chesmesi/features/special_order/data/data_source/delivery_method_data_source.dart';
// import 'package:new_kitap_chesmesi/features/special_order/data/data_source/special_order_data_source.dart';
// import 'package:new_kitap_chesmesi/features/special_order/data/repository/delivery_method_repository_impl.dart';
// import 'package:new_kitap_chesmesi/features/special_order/data/repository/special_order_repository_impl.dart';
// import 'package:new_kitap_chesmesi/features/special_order/domain/repository/delivery_method_repository.dart';
// import 'package:new_kitap_chesmesi/features/special_order/domain/repository/special_order_repository.dart';
// import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/approve_special_order/approve_special_order_cubit.dart';
// import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/create_special_order/create_special_order_cubit.dart';
// import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/delivery_method/delivery_method_cubit.dart';
// import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/special_order_detail/special_order_detail_cubit.dart';
// import 'package:new_kitap_chesmesi/features/special_order/presentation/cubit/special_orders/special_orders_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/data/data_source/contact_data_source.dart';
import 'package:new_kitap_chesmesi/features/profile/data/data_source/coupon_data_source.dart';
import 'package:new_kitap_chesmesi/features/profile/data/data_source/page_data_source.dart';
import 'package:new_kitap_chesmesi/features/profile/data/data_source/user_data_source.dart';
import 'package:new_kitap_chesmesi/features/profile/data/repository/contact_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/profile/data/repository/coupon_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/profile/data/repository/page_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/profile/data/repository/user_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/contact_repository.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/coupon_repository.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/page_repository.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/user_repository.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/contact/contact_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/coupon/coupon_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/page/page_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/user/user_cubit.dart';
import 'package:new_kitap_chesmesi/features/search/data/data_source/search_data_source.dart';
import 'package:new_kitap_chesmesi/features/search/data/repository/search_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/search/domain/repository/search_repository.dart';
import 'package:new_kitap_chesmesi/features/search/presentation/cubit/search_cubit.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:new_kitap_chesmesi/features/favorite/data/data_source/favorite_data_source.dart';
import 'package:new_kitap_chesmesi/features/favorite/domain/repository/favorite_repository.dart';
import 'package:new_kitap_chesmesi/features/favorite/data/repository/favorite_repository_impl.dart';
import 'package:new_kitap_chesmesi/core/service/notification_token_data_source.dart';
import 'package:new_kitap_chesmesi/core/service/service.dart';
import 'package:new_kitap_chesmesi/features/popup/data/data_sources/popup_data_source.dart';
import 'package:new_kitap_chesmesi/features/popup/domain/repositories/popup_repository.dart';
import 'package:new_kitap_chesmesi/features/popup/presentation/cubit/popup_cubit.dart';
import 'package:new_kitap_chesmesi/app/router/app_router.dart';
import 'package:new_kitap_chesmesi/main.dart' as main_app;

GetIt di = GetIt.instance;

initLocatorService() async {
  di.registerLazySingleton(() => const FlutterSecureStorage());
  di.registerLazySingleton(() => TalkerDioLogger());
  di.registerLazySingleton(() => LanguageService());
  di.registerLazySingleton(
    () => UpdateService(
      playStoreId: UpdateConfig.playStoreId,
      appleId: UpdateConfig.appleId.isEmpty ? null : UpdateConfig.appleId,
      appStoreCountry: UpdateConfig.appStoreCountry.isEmpty
          ? null
          : UpdateConfig.appStoreCountry,
      defaultEnforcement: UpdateConfig.forceUpdateEnabled
          ? UpdateEnforcement.mandatory
          : UpdateEnforcement.optional,
    ),
  );
  di.registerLazySingleton(() => FirebaseNotificatioService());

  registerTalker();

  registerDio();

  registerDataSource();

  registerRepository();

  registerCubit();
}

registerTalker() {
  final talker = TalkerFlutter.init();

  di.registerLazySingleton(() => talker);
}

registerDio() async {
  di.registerLazySingleton(() => Dio(BaseOptions(
        baseUrl: ApiConfig.apiBaseUrl,
      )));
  di.registerLazySingleton(
    () =>
        DioClient(di<FlutterSecureStorage>(), di<Dio>(), di<TalkerDioLogger>()),
  );
}

registerDataSource() {
  di.registerLazySingleton<ForgotPasswordDataSource>(
    () => ForgotPasswordDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton<LoginDataSource>(
    () => LoginDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton<UserDataSource>(
    () => UserDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton<ContactDataSource>(
    () => ContactDataSource(dioSettings: di<DioClient>()),
  );
  di.registerLazySingleton<CouponDataSource>(
    () => CouponDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton<PageDataSource>(
    () => PageDataSource(dioClient: di<DioClient>()),
  );
  di.registerLazySingleton<RegisterCodeOtpDataSource>(
    () => RegisterCodeOtpDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton<RegisterDataSource>(
    () => RegisterDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => CategoryDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => BooksByCategoryDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => BannerDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => SubcategoryDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => BookDetailDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => LatestBookDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => DiscountBookDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => BookPublisherDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => BookLanguageDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => BookAuthorDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => BookByAuthorDataSource(dioSetting: di<DioClient>()),
  );

  di.registerLazySingleton(
    () => SearchDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => BookByLanguageIdDataSoruce(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => FavoriteDataSoruce(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => CartDataSource(dioClient: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => GiftDataSource(dioClient: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => OrderDataSource(dioClient: di<DioClient>()),
  );
  // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
  // di.registerLazySingleton(
  // () => SpecialOrderDataSource(dioClient: di<DioClient>()),
  // );
  // di.registerLazySingleton(
  // () => DeliveryMethodDataSource(dioClient: di<DioClient>()),
  // );
  di.registerLazySingleton<CommentDataSource>(
    () => CommentDataSourceImpl(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => HomeDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => WelayatDataSource(dioClient: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => EtrapDataSource(dioClient: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => AllBooksDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => NotificationTokenDataSource(dioClient: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => PopupDataSource(dioClient: di<DioClient>()),
  );

  di.registerLazySingleton(
    () => NotificationDataSource(dioClient: di<DioClient>()),
  );
}

registerRepository() {
  di.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepositoryImpl(
        forgotPasswordDataSource: di<ForgotPasswordDataSource>()),
  );
  di.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(loginDataSource: di<LoginDataSource>()),
  );
  di.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userDataSource: di<UserDataSource>()),
  );
  di.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(contactDataSource: di<ContactDataSource>()),
  );
  di.registerLazySingleton<CouponRepository>(
    () => CouponRepositoryImpl(couponDataSource: di<CouponDataSource>()),
  );
  di.registerLazySingleton<PageRepository>(
    () => PageRepositoryImpl(pageDataSource: di<PageDataSource>()),
  );
  di.registerLazySingleton<RegisterCodeOtpRepository>(
    () => RegisterCodeOtpImpl(
        registerCodeOtpDataSource: di<RegisterCodeOtpDataSource>()),
  );
  di.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(dataSource: di<RegisterDataSource>()),
  );
  di.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(dataSource: di<CategoryDataSource>()),
  );

  di.registerLazySingleton<SubcateogryRepository>(
    () => SubcategoryRepositoryImpl(
        dataSource: di<SubcategoryDataSource>(), id: ''),
  );
  di.registerLazySingleton<BookDetailRepository>(() =>
      BookDetailRepositoryImpl(remoteDataSource: di<BookDetailDataSource>()));
  di.registerLazySingleton<LatestBookRepository>(() => LatestBookRepositoryImpl(
      latestBookDataSource: di<LatestBookDataSource>()));
  di.registerLazySingleton<DiscountedBookRepository>(() =>
      DiscountedBookRepositoryImpl(
          discountBookDataSource: di<DiscountBookDataSource>()));
  di.registerLazySingleton<BookPublisherRepository>(
    () => BookPublisherRepositoryImpl(
      dataSource: di<BookPublisherDataSource>(),
    ),
  );
  di.registerLazySingleton<BookLanguageRepository>(
    () => BookLanguageRepositoryImpl(
      dataSource: di<BookLanguageDataSource>(),
    ),
  );
  di.registerLazySingleton<BookAuthorRepository>(
    () => BookAuthorRepositoryImpl(
      dataSource: di<BookAuthorDataSource>(),
    ),
  );
  di.registerLazySingleton<BookByAuthorRepository>(() =>
      BookByAuthorRepositoryImpl(
          bookByAuthorDataSource: di<BookByAuthorDataSource>()));
  di.registerLazySingleton<BooksByCategoryRepository>(() =>
      BooksByCategoryRepositoryImpl(
          booksByCategoryDataSource: di<BooksByCategoryDataSource>()));
  di.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(searchDataSource: di<SearchDataSource>()));
  di.registerLazySingleton<BookByLanguageIdRepository>(() =>
      BookByLanguageIdRepositoryImpl(
          bookByLanguageIdDataSoruce: di<BookByLanguageIdDataSoruce>()));
  di.registerLazySingleton<FavoriteRepository>(() =>
      FavoriteRepositoryImpl(favoriteDataSource: di<FavoriteDataSoruce>()));
  di.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(cartDataSource: di<CartDataSource>()),
  );
  di.registerLazySingleton<GiftRepository>(
    () => GiftRepositoryImpl(giftDataSource: di<GiftDataSource>()),
  );
  di.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(orderDataSource: di<OrderDataSource>()),
  );
  // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
  // di.registerLazySingleton<SpecialOrderRepository>(
  // () => SpecialOrderRepositoryImpl(
  // specialOrderDataSource: di<SpecialOrderDataSource>(),
  // ),
  // );
  // di.registerLazySingleton<DeliveryMethodRepository>(
  // () => DeliveryMethodRepositoryImpl(
  // deliveryMethodDataSource: di<DeliveryMethodDataSource>(),
  // ),
  // );
  di.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(commentDataSource: di<CommentDataSource>()),
  );
  di.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(homeDataSource: di<HomeDataSource>()),
  );
  di.registerLazySingleton<WelayatRepository>(
    () => WelayatRepositoryImpl(welayatDataSource: di<WelayatDataSource>()),
  );
  di.registerLazySingleton<EtrapRepository>(
    () => EtrapRepositoryImpl(etrapDataSource: di<EtrapDataSource>()),
  );
  di.registerLazySingleton<AllBooksRepository>(
    () => AllBooksRepositoryImpl(dataSource: di<AllBooksDataSource>()),
  );
  di.registerLazySingleton<PopupRepository>(
    () => PopupRepository(dataSource: di<PopupDataSource>()),
  );
  di.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
        notificationDataSource: di<NotificationDataSource>()),
  );
}

registerCubit() {
  di.registerFactory(() =>
      ForgotCubit(forgotPasswordRepository: di<ForgotPasswordRepository>()));
  di.registerFactory(() => LoginCubit(
      loginRepository: di<LoginRepository>(),
      notificationTokenDataSource: di<NotificationTokenDataSource>(),
      firebaseNotificationService: di<FirebaseNotificatioService>()));
  di.registerFactory(() => UserCubit(userRepository: di<UserRepository>()));
  di.registerFactory(
      () => ContactCubit(contactRepository: di<ContactRepository>()));
  di.registerFactory(
      () => CouponCubit(couponRepository: di<CouponRepository>()));
  di.registerFactory(() => PageCubit(pageRepository: di<PageRepository>()));
  di.registerFactory(() => RegisterCodeCubit(
      registerCodeOtpRepository: di<RegisterCodeOtpRepository>()));
  di.registerFactory(() => RegisterCubit(
      registerRepository: di<RegisterRepository>(),
      notificationTokenDataSource: di<NotificationTokenDataSource>(),
      firebaseNotificationService: di<FirebaseNotificatioService>()));
  di.registerFactory(
      () => CategoryCubit(categoryRepository: di<CategoryRepository>()));
  di.registerFactory(() => BooksCubit(
      // repository: di<BooksByCategoryRepository>(),
      categoryRepository: di<BooksByCategoryRepository>(),
      latestRepository: di<LatestBookRepository>(),
      discountedRepository: di<DiscountedBookRepository>(),
      languageRepository: di<BookByLanguageIdRepository>(),
      homeRepository: di<HomeRepository>(),
      allBooksRepository: di<AllBooksRepository>()));
  di.registerFactory(
    () => BannerCubit(bannerDataSource: di<BannerDataSource>()),
  );

  di.registerFactory(() => SubcategoryCubit(di<SubcateogryRepository>()));
  di.registerFactory(
      () => GetBookByIdCubit(bookDetailRepository: di<BookDetailRepository>()));
  di.registerFactory(
      () => LatestBookCubit(bookRepository: di<LatestBookRepository>()));
  di.registerFactory(() => DiscountedBookCubit(
      discountedBookRepository: di<DiscountedBookRepository>()));
  di.registerFactory(() => BookByAuthorIdCubit(
      bookByAuthorRepository: di<BookByAuthorRepository>()));
  di.registerFactory(
      () => SearchCubit(searchRepository: di<SearchRepository>()));
  di.registerLazySingleton(
      () => FavoriteCubit(favoriteRepository: di<FavoriteRepository>()));
  di.registerFactory(() => CartCubit(cartRepository: di<CartRepository>()));
  di.registerFactory(() => GiftCubit(giftRepository: di<GiftRepository>()));
  di.registerFactory(() => OrderCubit(orderRepository: di<OrderRepository>()));
  di.registerFactory(
      () => MyOrdersCubit(orderRepository: di<OrderRepository>()));
  di.registerFactory(
      () => OrderDetailCubit(orderRepository: di<OrderRepository>()));
  // ÖZEL SİPARİŞ — geçici olarak kapatıldı.
  // di.registerFactory(() => SpecialOrdersCubit(
  // specialOrderRepository: di<SpecialOrderRepository>()));
  // di.registerFactory(() => SpecialOrderDetailCubit(
  // specialOrderRepository: di<SpecialOrderRepository>()));
  // di.registerFactory(() => CreateSpecialOrderCubit(
  // specialOrderRepository: di<SpecialOrderRepository>()));
  // di.registerFactory(() => ApproveSpecialOrderCubit(
  // specialOrderRepository: di<SpecialOrderRepository>()));
  // // Usul listesi nadiren değişir ve birden çok ekranda gerekiyor — tekil.
  // di.registerLazySingleton(() => DeliveryMethodCubit(
  // deliveryMethodRepository: di<DeliveryMethodRepository>()));
  di.registerFactory(
      () => CommentCubit(commentRepository: di<CommentRepository>()));
  di.registerFactory(() => HomeCubit(homeRepository: di<HomeRepository>()));
  di.registerFactory(() => WelayatAndEtrapCubit(
      welayatRepository: di<WelayatRepository>(),
      etrapRepository: di<EtrapRepository>()));
  di.registerFactory(() => PopupCubit(repository: di<PopupRepository>()));
  di.registerFactory(() =>
      NotificationCubit(notificationRepository: di<NotificationRepository>()));

  di.registerSingleton<AppRouter>(
    AppRouter(navigatorKey: main_app.navigatorKey),
  );
}
