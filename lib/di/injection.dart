import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:megabatako/core/connection/network_info.dart';
import 'package:megabatako/features/account/data/data_sources/account_remote_data_source.dart';
import 'package:megabatako/features/account/data/repositories_impl/account_repository_impl.dart';
import 'package:megabatako/features/account/domain/repositories/account_repository.dart';
import 'package:megabatako/features/account/domain/use_cases/get_current_user_use_case.dart';
import 'package:megabatako/features/account/presentation/blocs/cubit/get_current_user_cubit.dart';
import 'package:megabatako/features/auth/data/data_sources/remote_data_source.dart';
import 'package:megabatako/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:megabatako/features/auth/domain/repositories/auth_repository.dart';
import 'package:megabatako/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:megabatako/features/auth/presentation/blocs/cubit/sign_in_cubit.dart';
import 'package:megabatako/features/category/data/datasources/category_remote_data_source.dart';
import 'package:megabatako/features/category/data/repositories/category_repository_impl.dart';
import 'package:megabatako/features/category/domain/repositories/category_repository.dart';
import 'package:megabatako/features/category/domain/usecases/delete_category_use_case.dart';
import 'package:megabatako/features/category/domain/usecases/store_category_use_case.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/delete_product_category_cubit.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/get_product_category_cubit.dart';
import 'package:megabatako/features/category/presentation/bloc/cubit/store_product_category_cubit.dart';
import 'package:megabatako/features/image_picker/data/datasources/image_picker_data_source.dart';
import 'package:megabatako/features/image_picker/data/repositories/image_picker_repository_impl.dart';
import 'package:megabatako/features/image_picker/domain/repositories/image_picker_repository.dart';
import 'package:megabatako/features/image_picker/domain/usecases/choose_picture_use_case.dart';
import 'package:megabatako/features/image_picker/domain/usecases/take_picture_use_case.dart';
import 'package:megabatako/features/image_picker/presentation/bloc/cubit/image_picker_cubit.dart';
import 'package:megabatako/features/main_frame/presentation/blocs/cubit/navbar_cubit.dart';
import 'package:megabatako/features/products/data/data_sources/product_remote_data_source.dart';
import 'package:megabatako/features/products/data/repositories_impl/product_repository_impl.dart';
import 'package:megabatako/features/products/domain/repositories/product_repository.dart';
import 'package:megabatako/features/products/domain/use_cases/delete_product_use.dart';
import 'package:megabatako/features/category/domain/usecases/get_category_use_case.dart';
import 'package:megabatako/features/products/domain/use_cases/get_product_use_case.dart';
import 'package:megabatako/features/products/domain/use_cases/store_product_use_case.dart';
import 'package:megabatako/features/products/domain/use_cases/update_product_use_case.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/delete_product_cubit.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/get_product_by_category_cubit.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/store_product_cubit.dart';
import 'package:megabatako/features/products/presentation/blocs/cubit/update_product_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> initLocator() async {
  /// state management
  /// untuk registrasi state management, gunakan registerFactory
  locator.registerFactory(() => NavbarCubit());
  locator.registerFactory(() => SignInCubit(locator()));
  locator.registerFactory(() => GetCurrentUserCubit(locator()));
  locator.registerFactory(() => GetProductCategoryCubit(locator()));
  locator.registerFactory(() => ImagePickerCubit(choosePictureUseCase: locator(),takePictureUseCase: locator()));
  locator.registerFactory(() => StoreProductCubit(locator()));
  locator.registerFactory(() => DeleteProductCubit(locator()));
  locator.registerFactory(() => UpdateProductCubit(locator()));
  locator.registerFactory(() => StoreProductCategoryCubit(locator()));
  locator.registerFactory(() => GetProductByCategoryCubit(locator()));
  locator.registerFactory(() => DeleteProductCategoryCubit(locator()));

  ///business logic state

  /// usecase
  /// untuk registrasi use case, gunakan rqegisterLazySingleton
  locator.registerLazySingleton(() => SignInUseCase(locator()));
  locator.registerLazySingleton(() => GetCurrentUserUseCase(locator()));
  locator.registerLazySingleton(() => StoreProductCategoryUseCase(locator()));
  locator.registerLazySingleton(() => GetCategoryUseCase(locator()));
  locator.registerLazySingleton(() => DeleteCategoryUseCase(locator()));
  locator.registerLazySingleton(() => TakePictureUseCase(locator()));
  locator.registerLazySingleton(() => ChoosePictureUseCase(locator()));
  locator.registerLazySingleton(() => StoreProductUseCase(locator()));
  locator.registerLazySingleton(() => GetProductByCategoryUseCase(locator()));
  locator.registerLazySingleton(() => DeleteProductUseCase(locator()));
  locator.registerLazySingleton(() => UpdateProductUseCase(locator()));

  /// repository
  /// untuk registrasi repository, gunakan registerLazySingleton
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: locator(), 
      remoteDataSource: locator()),
  );
  locator.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      networkInfo: locator(), 
      remoteDataSource: locator()),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      networkInfo: locator(), 
      remoteDataSource: locator()),
  );
  locator.registerLazySingleton<ImagePickerRepository>(
    () => ImagePickerRepositoryImpl(locator())
  );
  locator.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      networkInfo: locator(), 
      remoteDataSource: locator()),
  );
  

  /// datasource
  /// untuk registrasi data source, gunakan registerLazySingleton

  // local data source
  // locator.registerLazySingleton<DashboardLocalDataSource>(
  //   () => DashboardLocalDataSourceImpl(pref: locator()),
  // );

  /// online data source
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: locator(), pref: locator()),
  );
  locator.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(client: locator(), pref: locator()),
  );
  locator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: locator(), pref: locator()),
  );
  locator.registerLazySingleton<ImagePickerDataSource>(
    () => ImagePickerDataSourceImpl(picker: locator()),
  );
  locator.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(client: locator(), pref: locator()),
  );

  ///device data source
  // locator.registerLazySingleton<PermissionDeviceDataSource>(
  //   () => PermissionDeviceDataSourceImpl(),
  // );

  /// platform
  /// untuk registrasi platform, gunakan registerLazySingleton
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: locator()),
  );

  /// external
  /// untuk registrasi hal lain, gunakan registerLazySingleton
  final sp = await SharedPreferences.getInstance();
  // LocalStorageSp.loginUser = await SharedPreferences.getInstance();

  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => Connectivity());
  locator.registerLazySingleton(() => ImagePicker());
  locator.registerLazySingleton(() => sp);
  // locator.registerLazySingleton(() => LocalStorageSp());

  // final NotificationHelper notificationHelper = NotificationHelper();
  // final BackgroundService service = BackgroundService();
  // service.initializeIsolate();
  // if (Platform.isAndroid) {
  //  await AndroidAlarmManager.initialize();
  // }
  // await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  // await FlutterDownloader.initialize(
  //     debug:
  //         true, // optional: set to false to disable printing logs to console (default: true)
  //     ignoreSsl:
  //         true // option: set to false to disable working with http links (default: false)
  //     );
}
