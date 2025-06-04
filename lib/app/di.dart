import 'package:get_it/get_it.dart';
import 'package:new_kitap_chesmesi/core/network/dio_client.dart';
import 'package:new_kitap_chesmesi/features/auth/data/data_source/auth_data_source.dart';
import 'package:new_kitap_chesmesi/features/auth/data/data_source/auth_data_source_impl.dart';
import 'package:new_kitap_chesmesi/features/auth/data/repository/auth_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/auth/domain/repository/auth_repository.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:new_kitap_chesmesi/features/book/data/data_source/books_data_source.dart';
import 'package:new_kitap_chesmesi/features/book/data/repository/books_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/book/domain/repository/books_repository.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/cubit/books_cubit.dart';
import 'package:new_kitap_chesmesi/features/category/data/data_source/category_data_source.dart';
import 'package:new_kitap_chesmesi/features/category/data/repository/category_repository_impl.dart';
import 'package:new_kitap_chesmesi/features/category/domain/repository/category_repository.dart';
import 'package:new_kitap_chesmesi/features/category/presentation/cubit/category_cubit.dart';
import 'package:new_kitap_chesmesi/features/favorite/presentation/cubit/cubit.dart';
import 'package:new_kitap_chesmesi/features/home/data_source/banner_data_source.dart';
import 'package:new_kitap_chesmesi/features/home/presentation/cubit/images_cubit.dart';
import 'package:new_kitap_chesmesi/features/order/data/data_source/order_data_source.dart';
import 'package:new_kitap_chesmesi/features/order/presentation/cubit/cubit.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';

GetIt di = GetIt.instance;

initLocatorService() async {
  di.registerLazySingleton(() => const FlutterSecureStorage());
  di.registerLazySingleton(() => TalkerDioLogger());

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
  // String baseUrl = 'http://localhost:8000/api/';
  String baseUrl = 'http://kitapcesmesi.com.tm/api/';
  di.registerLazySingleton(() => Dio(BaseOptions(baseUrl: baseUrl)));
  di.registerLazySingleton(
    () =>
        DioClient(di<FlutterSecureStorage>(), di<Dio>(), di<TalkerDioLogger>()),
  );
}

registerDataSource() {
  di.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(dio: di<Dio>()),
  );
  di.registerLazySingleton(
    () => CategoryDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => BooksDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => ImagesDataSource(dioSetting: di<DioClient>()),
  );
  di.registerLazySingleton(
    () => OrderDataSource(dioSetting: di<DioClient>()),
  );
}

registerRepository() {
  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: di<AuthDataSource>()),
  );
  di.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(dataSource: di<CategoryDataSource>()),
  );
  di.registerLazySingleton<BooksRepository>(
    () => BooksRepositoryImpl(dataSource: di<BooksDataSource>()),
  );
  di.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepository(secureStorage: di<FlutterSecureStorage>()),
  );
}

registerCubit() {
  di.registerFactory(() => AuthCubit(repository: di<AuthRepository>()));
  di.registerFactory(() => CategoryCubit(repository: di<CategoryRepository>()));
  di.registerFactory(() => BooksCubit(repository: di<BooksRepository>()));
  di.registerFactory(() => ImagesCubit(dataSource: di<ImagesDataSource>()));
  di.registerFactory(() => FavoriteCubit(favoriteRepository: di<FavoriteRepository>()));
  di.registerFactory(() => OrderCubit(di<OrderDataSource>()));
}
