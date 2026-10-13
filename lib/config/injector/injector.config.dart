// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:clean_architecture/config/app_config.dart' as _i37;
import 'package:clean_architecture/config/injector/http_module.dart' as _i515;
import 'package:clean_architecture/core/network/network_info.dart' as _i341;
import 'package:clean_architecture/core/network/offline_sync_manager.dart'
    as _i1037;
import 'package:clean_architecture/core/services/api/api_service.dart' as _i885;
import 'package:clean_architecture/core/services/auth/token_refresher.dart'
    as _i145;
import 'package:clean_architecture/core/services/database/local_database_service.dart'
    as _i87;
import 'package:clean_architecture/core/services/image_picker/image_picker_service.dart'
    as _i257;
import 'package:clean_architecture/core/services/internet/internet_service.dart'
    as _i662;
import 'package:clean_architecture/core/services/navigation/navigation_service.dart'
    as _i1005;
import 'package:clean_architecture/core/services/pdf/pdf_export_service.dart'
    as _i1021;
import 'package:clean_architecture/core/services/realtime/websocket_service.dart'
    as _i474;
import 'package:clean_architecture/core/services/session/session_service.dart'
    as _i497;
import 'package:clean_architecture/core/services/speech/speech_service.dart'
    as _i332;
import 'package:clean_architecture/features/auth/data/data_sources/auth_local_data_source.dart'
    as _i322;
import 'package:clean_architecture/features/auth/data/data_sources/auth_remote_data_source.dart'
    as _i141;
import 'package:clean_architecture/features/auth/data/repositories/auth_repository_impl.dart'
    as _i526;
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart'
    as _i1003;
import 'package:clean_architecture/features/auth/domain/use_cases/change_password_use_case.dart'
    as _i750;
import 'package:clean_architecture/features/auth/domain/use_cases/check_authentication_use_case.dart'
    as _i481;
import 'package:clean_architecture/features/auth/domain/use_cases/get_user_data_use_case.dart'
    as _i817;
import 'package:clean_architecture/features/auth/domain/use_cases/login_use_case.dart'
    as _i68;
import 'package:clean_architecture/features/auth/domain/use_cases/logout_use_case.dart'
    as _i426;
import 'package:clean_architecture/features/auth/domain/use_cases/refresh_token_use_case.dart'
    as _i144;
import 'package:clean_architecture/features/auth/domain/use_cases/save_user_data_use_case.dart'
    as _i661;
import 'package:clean_architecture/features/auth/domain/use_cases/verify_user_use_case.dart'
    as _i13;
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart'
    as _i912;
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit_use_cases.dart'
    as _i123;
import 'package:clean_architecture/features/connections/dashboard/data/datasources/dashboard_remote_datasource.dart'
    as _i48;
import 'package:clean_architecture/features/connections/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i951;
import 'package:clean_architecture/features/connections/dashboard/domain/repositories/dashboard_repository.dart'
    as _i353;
import 'package:clean_architecture/features/connections/dashboard/domain/usecases/get_dashboard_stats.dart'
    as _i671;
import 'package:clean_architecture/features/connections/dashboard/domain/usecases/watch_dashboard_stats.dart'
    as _i749;
import 'package:clean_architecture/features/connections/data/datasources/remote/connection_remote_datasource.dart'
    as _i1016;
import 'package:clean_architecture/features/connections/data/repositories/connection_repository_impl.dart'
    as _i17;
import 'package:clean_architecture/features/connections/domain/repositories/connection_repository.dart'
    as _i459;
import 'package:clean_architecture/features/connections/domain/usecases/connection_use_case.dart'
    as _i788;
import 'package:clean_architecture/features/connections/form/add-img/data/datasources/property_image_remote_data_source.dart'
    as _i40;
import 'package:clean_architecture/features/connections/form/add-img/data/repositories/property_image_repository_impl.dart'
    as _i865;
import 'package:clean_architecture/features/connections/form/add-img/domain/repositories/property_image_repository.dart'
    as _i29;
import 'package:clean_architecture/features/connections/form/add-img/domain/usecases/add_property_images.dart'
    as _i64;
import 'package:clean_architecture/features/connections/form/documents/data/datasources/document_remote_datasource.dart'
    as _i549;
import 'package:clean_architecture/features/connections/form/documents/data/repositories/document_repository_impl.dart'
    as _i522;
import 'package:clean_architecture/features/connections/form/documents/domain/repositories/document_repository.dart'
    as _i392;
import 'package:clean_architecture/features/connections/form/documents/domain/usecases/upload_document_usecase.dart'
    as _i472;
import 'package:clean_architecture/features/connections/form/update/data/datasources/company_remote_data_source.dart'
    as _i142;
import 'package:clean_architecture/features/connections/form/update/data/datasources/connection_remote_data_source.dart'
    as _i505;
import 'package:clean_architecture/features/connections/form/update/data/datasources/customer_remote_data_source.dart'
    as _i293;
import 'package:clean_architecture/features/connections/form/update/data/datasources/observation_connection_remote_data_source.dart'
    as _i1024;
import 'package:clean_architecture/features/connections/form/update/data/datasources/property_remote_data_source.dart'
    as _i1043;
import 'package:clean_architecture/features/connections/form/update/data/repositories/connection_repository_impl.dart'
    as _i700;
import 'package:clean_architecture/features/connections/form/update/data/repositories/observation_connection_repository_impl.dart'
    as _i338;
import 'package:clean_architecture/features/connections/form/update/domain/repositories/connection_repository.dart'
    as _i186;
import 'package:clean_architecture/features/connections/form/update/domain/repositories/observation_connection_repository.dart'
    as _i1071;
import 'package:clean_architecture/features/connections/form/update/domain/usecases/add_observation_connection.dart'
    as _i893;
import 'package:clean_architecture/features/connections/form/update/domain/usecases/change_meter_usecase.dart'
    as _i198;
import 'package:clean_architecture/features/connections/form/update/domain/usecases/update_connection.dart'
    as _i237;
import 'package:clean_architecture/features/connections/search/data/datasources/local_connection_datasource.dart'
    as _i274;
import 'package:clean_architecture/features/connections/search/data/datasources/remote_connection_datasource.dart'
    as _i1039;
import 'package:clean_architecture/features/connections/search/data/datasources/remote_connection_with_properties_datasource.dart'
    as _i598;
import 'package:clean_architecture/features/connections/search/data/repositories/connection_with_properties_repository_impl.dart'
    as _i2;
import 'package:clean_architecture/features/connections/search/data/repositories/search_connection_repository_impl.dart'
    as _i713;
import 'package:clean_architecture/features/connections/search/data/services/map_navigation_service_impl.dart'
    as _i959;
import 'package:clean_architecture/features/connections/search/domain/repositories/connection_with_properties_repository.dart'
    as _i1032;
import 'package:clean_architecture/features/connections/search/domain/services/map_navigation_service.dart'
    as _i449;
import 'package:clean_architecture/features/connections/search/domain/usecases/find_property_with_client.dart'
    as _i519;
import 'package:clean_architecture/features/connections/search/domain/usecases/get_connection_with_properties.dart'
    as _i453;
import 'package:clean_architecture/features/connections/search/presentation/info/cubit/search_connection_cubit.dart'
    as _i22;
import 'package:clean_architecture/features/connections/search/presentation/manually/blocs/manually_connection_with_properties_bloc.dart'
    as _i372;
import 'package:clean_architecture/features/connections/search/presentation/scan/blocs/connection_with_properties_bloc.dart'
    as _i981;
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart'
    as _i278;
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit_use_cases.dart'
    as _i134;
import 'package:clean_architecture/features/incidents/data/datasources/incident_remote_datasource.dart'
    as _i560;
import 'package:clean_architecture/features/incidents/data/repositories/incident_repository_impl.dart'
    as _i397;
import 'package:clean_architecture/features/incidents/domain/repositories/incident_repository.dart'
    as _i878;
import 'package:clean_architecture/features/incidents/domain/usecases/create_incident.dart'
    as _i390;
import 'package:clean_architecture/features/incidents/domain/usecases/find_incident_by_id.dart'
    as _i943;
import 'package:clean_architecture/features/incidents/domain/usecases/find_incident_categories.dart'
    as _i115;
import 'package:clean_architecture/features/incidents/domain/usecases/find_incidents.dart'
    as _i948;
import 'package:clean_architecture/features/incidents/domain/usecases/find_incidents_by_connection.dart'
    as _i542;
import 'package:clean_architecture/features/incidents/domain/usecases/get_incident_dashboard_kpis.dart'
    as _i672;
import 'package:clean_architecture/features/incidents/domain/usecases/resolve_incident.dart'
    as _i606;
import 'package:clean_architecture/features/incidents/presentation/cubit/incident_cubit.dart'
    as _i600;
import 'package:clean_architecture/features/products/data/datasource/remote/product_material_remote_datasource.dart'
    as _i311;
import 'package:clean_architecture/features/products/data/repositories/product_material_repository_impl.dart'
    as _i262;
import 'package:clean_architecture/features/products/domain/repositories/product_material_repository.dart'
    as _i187;
import 'package:clean_architecture/features/products/domain/usecases/product_material_use_case.dart'
    as _i794;
import 'package:clean_architecture/features/profile/presentation/cubit/change_password_cubit.dart'
    as _i303;
import 'package:clean_architecture/features/reading/data/datasources/remote_reading_data_source.dart'
    as _i100;
import 'package:clean_architecture/features/reading/data/repositories/reading_repository_impl.dart'
    as _i426;
import 'package:clean_architecture/features/reading/domain/repositories/reading_repository.dart'
    as _i76;
import 'package:clean_architecture/features/reading/domain/usecases/create_reading_usecase.dart'
    as _i41;
import 'package:clean_architecture/features/reading/domain/usecases/get_reading_info.dart'
    as _i151;
import 'package:clean_architecture/features/reading/presentation/manually/blocs/reading_manually_bloc.dart'
    as _i797;
import 'package:clean_architecture/features/reading/presentation/scan/bloc/reading_scan_bloc.dart'
    as _i185;
import 'package:clean_architecture/features/users/data/datasources/user_remote_datasource.dart'
    as _i890;
import 'package:clean_architecture/features/users/data/repositories/user_repository_impl.dart'
    as _i163;
import 'package:clean_architecture/features/users/domain/repositories/user_repository.dart'
    as _i486;
import 'package:clean_architecture/features/users/domain/usecases/user_use_cases.dart'
    as _i605;
import 'package:clean_architecture/features/work-orders/data/datasource/remote/add_material_work_order_remote_datasource.dart'
    as _i934;
import 'package:clean_architecture/features/work-orders/data/datasource/remote/add_work_order_assignment_remote_data_source.dart'
    as _i393;
import 'package:clean_architecture/features/work-orders/data/datasource/remote/add_work_order_attachment_remote_data_source.dart'
    as _i286;
import 'package:clean_architecture/features/work-orders/data/datasource/remote/work_orders_remote_datasource.dart'
    as _i370;
import 'package:clean_architecture/features/work-orders/data/repositories/add_material_work_order_repository_impl.dart'
    as _i579;
import 'package:clean_architecture/features/work-orders/data/repositories/add_work_order_assigment_repository_impl.dart'
    as _i359;
import 'package:clean_architecture/features/work-orders/data/repositories/add_work_order_attachment_repository_impl.dart'
    as _i475;
import 'package:clean_architecture/features/work-orders/data/repositories/work_order_repository_impl.dart'
    as _i448;
import 'package:clean_architecture/features/work-orders/domain/repositories/add_material_work_order_repository.dart'
    as _i824;
import 'package:clean_architecture/features/work-orders/domain/repositories/add_work_order_assignment_repository.dart'
    as _i1041;
import 'package:clean_architecture/features/work-orders/domain/repositories/add_work_order_attachment_repository.dart'
    as _i386;
import 'package:clean_architecture/features/work-orders/domain/repositories/work_order_repository.dart'
    as _i464;
import 'package:clean_architecture/features/work-orders/domain/usecases/add_material_work_order_use_case.dart'
    as _i985;
import 'package:clean_architecture/features/work-orders/domain/usecases/add_work_order_assignment_use_case.dart'
    as _i329;
import 'package:clean_architecture/features/work-orders/domain/usecases/add_work_order_attachment_use_case.dart'
    as _i12;
import 'package:clean_architecture/features/work-orders/domain/usecases/create_work_order_use_case.dart'
    as _i780;
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart'
    as _i817;
import 'package:clean_architecture/features/work-orders/domain/usecases/process/create_work_order_from_incident_use_case.dart'
    as _i119;
import 'package:clean_architecture/features/work-orders/domain/usecases/process/get_work_order_detail_use_case.dart'
    as _i835;
import 'package:clean_architecture/features/work-orders/domain/usecases/process/get_work_order_tracking_use_case.dart'
    as _i241;
import 'package:clean_architecture/features/work-orders/domain/usecases/process/process_work_order_use_cases.dart'
    as _i56;
import 'package:clean_architecture/features/work-orders/presentation/cubits/add-materials/add-materials_work_orde_cubit.dart'
    as _i943;
import 'package:clean_architecture/features/work-orders/presentation/cubits/create_work_order/create_work_order_cubit.dart'
    as _i841;
import 'package:clean_architecture/features/work-orders/presentation/cubits/process/work_order_process_cubit.dart'
    as _i707;
import 'package:clean_architecture/features/workers/data/datasource/worker_remote_datasource.dart'
    as _i105;
import 'package:clean_architecture/features/workers/data/repositories/worker_repository_impl.dart'
    as _i932;
import 'package:clean_architecture/features/workers/domain/repositories/worker_repository.dart'
    as _i163;
import 'package:clean_architecture/features/workers/domain/usecases/get_all_workers_use_case.dart'
    as _i451;
import 'package:clean_architecture/routing/routes.dart' as _i671;
import 'package:clean_architecture/shared/files/data/datasources/file_remote_datasource.dart'
    as _i399;
import 'package:clean_architecture/shared/files/data/repositories/file_repository_impl.dart'
    as _i103;
import 'package:clean_architecture/shared/files/domain/repositories/file_repository.dart'
    as _i876;
import 'package:clean_architecture/shared/files/domain/usecases/file_use_cases.dart'
    as _i964;
import 'package:clean_architecture/shared_ui/cubits/screen_observer/screen_observer_cubit.dart'
    as _i640;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

const String _staging = 'staging';
const String _development = 'development';
const String _production = 'production';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initialize({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final apiServiceModule = _$ApiServiceModule();
    final localDatabaseServiceModule = _$LocalDatabaseServiceModule();
    final httpModule = _$HttpModule();
    final imagePickerServiceModule = _$ImagePickerServiceModule();
    final internetServiceModule = _$InternetServiceModule();
    final navigationServiceModule = _$NavigationServiceModule();
    gh.factory<_i1037.OfflineSyncManager>(() => _i1037.OfflineSyncManager());
    gh.factory<bool>(() => apiServiceModule.addInterceptors);
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => localDatabaseServiceModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i640.ScreenObserverCubit>(() => _i640.ScreenObserverCubit());
    gh.lazySingleton<_i519.Client>(() => httpModule.client);
    gh.lazySingleton<_i361.Dio>(() => apiServiceModule.dio);
    gh.lazySingleton<_i183.ImagePicker>(
      () => imagePickerServiceModule.imagePicker,
    );
    gh.lazySingleton<_i161.InternetConnection>(
      () => internetServiceModule.internetConnection,
    );
    gh.lazySingleton<_i671.AppRouter>(() => navigationServiceModule.appRouter);
    gh.factory<_i341.NetworkInfo>(() => _i341.NetworkInfoImpl());
    gh.lazySingleton<_i948.FindIncidentsParams>(
      () => _i948.FindIncidentsParams(
        connectionId: gh<String>(),
        status: gh<String>(),
        priority: gh<String>(),
        incidentTypeId: gh<int>(),
        sector: gh<int>(),
      ),
    );
    gh.lazySingleton<_i257.ImagePickerService>(
      () => _i257.ImagePickerServiceImpl(imagePicker: gh<_i183.ImagePicker>()),
    );
    gh.lazySingleton<_i332.SpeechService>(() => _i332.SpeechServiceImpl());
    gh.lazySingleton<_i1021.PdfExportService>(
      () => _i1021.PdfExportServiceImpl(),
    );
    gh.lazySingleton<_i449.MapNavigationService>(
      () => _i959.MapNavigationServiceImpl(),
    );
    gh.lazySingleton<_i37.AppConfig>(
      () => _i37.AppConfigStg(),
      registerFor: {_staging},
    );
    gh.lazySingleton<_i1005.NavigationService>(
      () => _i1005.NavigationServiceImpl(appRouter: gh<_i671.AppRouter>()),
    );
    gh.lazySingleton<_i662.InternetService>(
      () => _i662.InternetServiceImpl(
        internetConnection: gh<_i161.InternetConnection>(),
      ),
    );
    gh.lazySingleton<_i274.LocalConnectionDataSource>(
      () => _i274.LocalConnectionDataSourceImpl(
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i37.AppConfig>(
      () => _i37.AppConfigDev(),
      registerFor: {_development},
    );
    gh.lazySingleton<_i560.IncidentRemoteDataSource>(
      () => _i560.IncidentRemoteDataSourceImpl(client: gh<_i519.Client>()),
    );
    gh.lazySingleton<_i87.LocalDatabaseService>(
      () => _i87.LocalDatabaseServiceImpl(
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i37.AppConfig>(
      () => _i37.AppConfigProd(),
      registerFor: {_production},
    );
    gh.lazySingleton<_i878.IncidentRepository>(
      () => _i397.IncidentRepositoryImpl(
        remoteDataSource: gh<_i560.IncidentRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i497.SessionService>(
      () => _i497.SessionServiceImpl(
        localDatabase: gh<_i87.LocalDatabaseService>(),
        navigationService: gh<_i1005.NavigationService>(),
      ),
    );
    gh.lazySingleton<_i322.AuthLocalDataSource>(
      () => _i322.AuthLocalDataSourceImpl(
        localDatabase: gh<_i87.LocalDatabaseService>(),
      ),
    );
    gh.lazySingleton<_i390.CreateIncidentUseCase>(
      () => _i390.CreateIncidentUseCase(gh<_i878.IncidentRepository>()),
    );
    gh.lazySingleton<_i943.FindIncidentByIdUseCase>(
      () => _i943.FindIncidentByIdUseCase(gh<_i878.IncidentRepository>()),
    );
    gh.lazySingleton<_i115.FindIncidentCategoriesUseCase>(
      () => _i115.FindIncidentCategoriesUseCase(gh<_i878.IncidentRepository>()),
    );
    gh.lazySingleton<_i948.FindIncidentsUseCase>(
      () => _i948.FindIncidentsUseCase(gh<_i878.IncidentRepository>()),
    );
    gh.lazySingleton<_i542.FindIncidentsByConnectionUseCase>(
      () => _i542.FindIncidentsByConnectionUseCase(
        gh<_i878.IncidentRepository>(),
      ),
    );
    gh.lazySingleton<_i672.GetIncidentDashboardKpis>(
      () => _i672.GetIncidentDashboardKpis(gh<_i878.IncidentRepository>()),
    );
    gh.lazySingleton<_i606.ResolveIncidentUseCase>(
      () => _i606.ResolveIncidentUseCase(gh<_i878.IncidentRepository>()),
    );
    gh.lazySingleton<_i474.WebSocketService>(
      () => _i474.SocketIOWebSocketService(gh<_i497.SessionService>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i145.TokenRefresher>(
      () => _i145.TokenRefresherImpl(gh<_i37.AppConfig>()),
    );
    gh.lazySingleton<_i885.AuthInterceptor>(
      () => _i885.AuthInterceptor(gh<_i37.AppConfig>()),
    );
    gh.factory<_i600.IncidentCubit>(
      () => _i600.IncidentCubit(
        createIncidentUseCase: gh<_i390.CreateIncidentUseCase>(),
        resolveIncidentUseCase: gh<_i606.ResolveIncidentUseCase>(),
        findIncidentsByConnectionUseCase:
            gh<_i542.FindIncidentsByConnectionUseCase>(),
        findIncidentByIdUseCase: gh<_i943.FindIncidentByIdUseCase>(),
        findIncidentsUseCase: gh<_i948.FindIncidentsUseCase>(),
        findIncidentCategoriesUseCase:
            gh<_i115.FindIncidentCategoriesUseCase>(),
      ),
    );
    gh.lazySingleton<_i885.ApiService>(
      () => _i885.ApiServiceImpl(
        dio: gh<_i361.Dio>(),
        appConfig: gh<_i37.AppConfig>(),
        authInterceptor: gh<_i885.AuthInterceptor>(),
        navigationService: gh<_i1005.NavigationService>(),
        addInterceptors: gh<bool>(),
      ),
    );
    gh.lazySingleton<_i549.DocumentRemoteDataSource>(
      () => _i549.DocumentRemoteDataSourceImpl(gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i40.PropertyImageRemoteDataSource>(
      () => _i40.PropertyImageRemoteDataSourceImpl(gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i142.CompanyRemoteDataSource>(
      () => _i142.CompanyRemoteDataSource(gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i505.ConnectionRemoteDataSource>(
      () => _i505.ConnectionRemoteDataSource(gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i293.CustomerRemoteDataSource>(
      () => _i293.CustomerRemoteDataSource(gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i1024.ObservationConnectionRemoteDataSource>(
      () =>
          _i1024.ObservationConnectionRemoteDataSource(gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i1043.PropertyRemoteDataSource>(
      () => _i1043.PropertyRemoteDataSource(gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i29.PropertyImageRepository>(
      () => _i865.PropertyImageRepositoryImpl(
        gh<_i40.PropertyImageRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1039.RemoteConnectionDataSource>(
      () => _i1039.RemoteConnectionDataSourceImpl(gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i393.AddWorkOrderAssignmentRemoteDataSource>(
      () => _i393.AddWorkOrderAssignmentRemoteDataSourceImpl(
        apiService: gh<_i885.ApiService>(),
      ),
    );
    gh.lazySingleton<_i105.WorkerPaginatedRemoteDatasource>(
      () => _i105.WorkerPaginatedRemoteDatasourceImpl(
        apiService: gh<_i885.ApiService>(),
      ),
    );
    gh.lazySingleton<_i890.UserRemoteDataSource>(
      () => _i890.UserRemoteDataSourceImpl(apiService: gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i100.RemoteReadingDataSource>(
      () =>
          _i100.RemoteReadingDataSourceImpl(apiService: gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i1016.ConnectionPaginatedRemoteDatasource>(
      () => _i1016.ConnectionPaginatedRemoteDatasourceImpl(
        apiService: gh<_i885.ApiService>(),
      ),
    );
    gh.lazySingleton<_i311.ProductMaterialPaginatedRemoteDatasource>(
      () => _i311.ProductMaterialPaginatedRemoteDatasourceImpl(
        apiService: gh<_i885.ApiService>(),
      ),
    );
    gh.lazySingleton<_i186.UpdateConnectionRepository>(
      () => _i700.UpdateConnectionRepositoryImpl(
        remoteDataSource: gh<_i505.ConnectionRemoteDataSource>(),
        offlineSyncManager: gh<_i1037.OfflineSyncManager>(),
        networkInfo: gh<_i341.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i311.ProductMaterialRemoteDatasource>(
      () => _i311.ProductMaterialRemoteDatasourceImpl(
        apiService: gh<_i885.ApiService>(),
      ),
    );
    gh.lazySingleton<_i141.AuthRemoteDataSource>(
      () => _i141.AuthRemoteDataSourceImpl(dioClient: gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i105.WorkerRemoteDatasource>(
      () =>
          _i105.WorkerRemoteDatasourceImpl(apiService: gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i286.AddWorkOrderAttachmentRemoteDataSource>(
      () => _i286.AddWorkOrderAttachmentRemoteDataSourceImpl(
        apiService: gh<_i885.ApiService>(),
      ),
    );
    gh.lazySingleton<_i1071.ObservationConnectionRepository>(
      () => _i338.ObservationConnectionRepositoryImpl(
        remoteDataSource: gh<_i1024.ObservationConnectionRemoteDataSource>(),
        offlineSyncManager: gh<_i1037.OfflineSyncManager>(),
        networkInfo: gh<_i341.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i934.AddMaterialWorkOrderRemoteDatasource>(
      () => _i934.AddMaterialWorkOrderRemoteDatasourceImpl(
        apiService: gh<_i885.ApiService>(),
      ),
    );
    gh.lazySingleton<_i399.FileRemoteDataSource>(
      () => _i399.FileRemoteDataSourceImpl(gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i187.ProductMaterialRepository>(
      () => _i262.ProductMaterialRepositoryImpl(
        internet: gh<_i662.InternetService>(),
        remoteDataSource: gh<_i311.ProductMaterialRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i824.AddMaterialWorkOrderRepository>(
      () => _i579.AddMaterialWorkOrderRepositoryImpl(
        remoteDataSource: gh<_i934.AddMaterialWorkOrderRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i76.ReadingRepository>(
      () => _i426.ReadingRepositoryImpl(gh<_i100.RemoteReadingDataSource>()),
    );
    gh.lazySingleton<_i794.GetAllProductMaterialsUseCase>(
      () => _i794.GetAllProductMaterialsUseCase(
        gh<_i187.ProductMaterialRepository>(),
      ),
    );
    gh.lazySingleton<_i370.WorkOrdersRemoteDataSource>(
      () => _i370.WorkOrdersRemoteDataSourceImpl(
        apiService: gh<_i885.ApiService>(),
      ),
    );
    gh.lazySingleton<_i1016.ConnectionRemoteDatasource>(
      () => _i1016.ConnectionRemoteDatasourceImpl(
        apiService: gh<_i885.ApiService>(),
      ),
    );
    gh.lazySingleton<_i163.WorkerRepository>(
      () => _i932.WorkerRepositoryImpl(
        internetService: gh<_i662.InternetService>(),
        remoteDatasource: gh<_i105.WorkerRemoteDatasource>(),
      ),
    );
    gh.factory<_i198.ChangeMeterUseCase>(
      () => _i198.ChangeMeterUseCase(gh<_i186.UpdateConnectionRepository>()),
    );
    gh.factory<_i237.UpdateConnectionUseCase>(
      () =>
          _i237.UpdateConnectionUseCase(gh<_i186.UpdateConnectionRepository>()),
    );
    gh.lazySingleton<_i459.ConnectionPaginatedRepository>(
      () => _i17.ConnectionPaginatedRepositoryImpl(
        remoteDatasource: gh<_i1016.ConnectionPaginatedRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i788.GetAllConnectionsPaginatedUseCase>(
      () => _i788.GetAllConnectionsPaginatedUseCase(
        gh<_i459.ConnectionPaginatedRepository>(),
      ),
    );
    gh.lazySingleton<_i187.ProductMaterialPaginatedRepository>(
      () => _i262.ProductMaterialPaginatedRepositoryImpl(
        internet: gh<_i662.InternetService>(),
        remoteDataSource: gh<_i311.ProductMaterialPaginatedRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i598.RemoteConnectionWithPropertiesDataSource>(
      () => _i598.RemoteConnectionWithPropertiesDataSourceImpl(
        gh<_i885.ApiService>(),
      ),
    );
    gh.lazySingleton<_i451.GetAllWorkersUseCase>(
      () => _i451.GetAllWorkersUseCase(gh<_i163.WorkerRepository>()),
    );
    gh.lazySingleton<_i1032.SearchConnectionRepository>(
      () => _i713.SearchConnectionRepositoryImpl(
        remoteConnectionDataSource: gh<_i1039.RemoteConnectionDataSource>(),
        localConnectionDataSource: gh<_i274.LocalConnectionDataSource>(),
        networkInfo: gh<_i341.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i64.AddPropertyImagesUseCase>(
      () => _i64.AddPropertyImagesUseCase(gh<_i29.PropertyImageRepository>()),
    );
    gh.lazySingleton<_i163.WorkerPaginatedRepository>(
      () => _i932.WorkerPaginatedRepositoryImpl(
        internetService: gh<_i662.InternetService>(),
        remoteDatasource: gh<_i105.WorkerPaginatedRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i392.DocumentRepository>(
      () => _i522.DocumentRepositoryImpl(gh<_i549.DocumentRemoteDataSource>()),
    );
    gh.lazySingleton<_i48.DashboardRemoteDataSource>(
      () => _i48.DashboardRemoteDataSourceImpl(gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i386.AddWorkOrderAttachmentRepository>(
      () => _i475.AddWorkOrderAttachmentRepositoryImpl(
        remoteDataSource: gh<_i286.AddWorkOrderAttachmentRemoteDataSource>(),
      ),
    );
    gh.factory<_i893.AddObservationConnectionUseCase>(
      () => _i893.AddObservationConnectionUseCase(
        gh<_i1071.ObservationConnectionRepository>(),
      ),
    );
    gh.lazySingleton<_i41.CreateReadingUseCase>(
      () => _i41.CreateReadingUseCase(gh<_i76.ReadingRepository>()),
    );
    gh.lazySingleton<_i151.GetReadingInfo>(
      () => _i151.GetReadingInfo(gh<_i76.ReadingRepository>()),
    );
    gh.lazySingleton<_i464.WorkOrderRepository>(
      () => _i448.WorkOrderRepositoryImpl(
        internet: gh<_i662.InternetService>(),
        remoteDataSource: gh<_i370.WorkOrdersRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i353.DashboardRepository>(
      () => _i951.DashboardRepositoryImpl(
        remoteDataSource: gh<_i48.DashboardRemoteDataSource>(),
        pollingInterval: gh<Duration>(),
      ),
    );
    gh.lazySingleton<_i486.UserRepository>(
      () => _i163.UserRepositoryImpl(
        internet: gh<_i662.InternetService>(),
        remoteDataSource: gh<_i890.UserRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1041.AddWorkOrderAssignmentRepository>(
      () => _i359.AddWorkOrderAssignmentRepositoryImpl(
        remoteDataSource: gh<_i393.AddWorkOrderAssignmentRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i794.GetAllProductMaterialsPaginatedUseCase>(
      () => _i794.GetAllProductMaterialsPaginatedUseCase(
        gh<_i187.ProductMaterialPaginatedRepository>(),
      ),
    );
    gh.lazySingleton<_i1003.AuthRepository>(
      () => _i526.AuthRepositoryImpl(
        internet: gh<_i662.InternetService>(),
        remoteDataSource: gh<_i141.AuthRemoteDataSource>(),
        localDataSource: gh<_i322.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i459.ConnectionRepository>(
      () => _i17.ConnectionRepositoryImpl(
        remoteDatasource: gh<_i1016.ConnectionRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i1032.ConnectionWithPropertiesRepository>(
      () => _i2.ConnectionWithPropertiesRepositoryImpl(
        remoteConnectionWithPropertiesDataSource:
            gh<_i598.RemoteConnectionWithPropertiesDataSource>(),
        localConnectionDataSource: gh<_i274.LocalConnectionDataSource>(),
        networkInfo: gh<_i341.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i481.CheckAuthenticationUseCase>(
      () => _i481.CheckAuthenticationUseCase(
        authRepository: gh<_i1003.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i817.GetUserDataUseCase>(
      () =>
          _i817.GetUserDataUseCase(authRepository: gh<_i1003.AuthRepository>()),
    );
    gh.lazySingleton<_i68.LoginUseCase>(
      () => _i68.LoginUseCase(authRepository: gh<_i1003.AuthRepository>()),
    );
    gh.lazySingleton<_i661.SaveUserDataUseCase>(
      () => _i661.SaveUserDataUseCase(
        authRepository: gh<_i1003.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i451.GetAllWorkersPaginatedUseCase>(
      () => _i451.GetAllWorkersPaginatedUseCase(
        gh<_i163.WorkerPaginatedRepository>(),
      ),
    );
    gh.lazySingleton<_i472.UploadDocumentUseCase>(
      () => _i472.UploadDocumentUseCase(gh<_i392.DocumentRepository>()),
    );
    gh.lazySingleton<_i329.AddWorkOrderAssignmentUseCase>(
      () => _i329.AddWorkOrderAssignmentUseCase(
        gh<_i1041.AddWorkOrderAssignmentRepository>(),
      ),
    );
    gh.lazySingleton<_i134.DashboardCubitUseCases>(
      () => _i134.DashboardCubitUseCases(
        checkAuthentication: gh<_i481.CheckAuthenticationUseCase>(),
      ),
    );
    gh.factory<_i519.FindPropertyWithClient>(
      () =>
          _i519.FindPropertyWithClient(gh<_i1032.SearchConnectionRepository>()),
    );
    gh.factory<_i453.GetConnection>(
      () => _i453.GetConnection(gh<_i1032.SearchConnectionRepository>()),
    );
    gh.factory<_i797.ReadingManuallyBloc>(
      () => _i797.ReadingManuallyBloc(gh<_i151.GetReadingInfo>()),
    );
    gh.factory<_i185.ReadingScanBloc>(
      () => _i185.ReadingScanBloc(gh<_i151.GetReadingInfo>()),
    );
    gh.lazySingleton<_i985.AddMaterialWorkOrderUseCase>(
      () => _i985.AddMaterialWorkOrderUseCase(
        gh<_i824.AddMaterialWorkOrderRepository>(),
      ),
    );
    gh.lazySingleton<_i876.FileRepository>(
      () => _i103.FileRepositoryImpl(gh<_i399.FileRemoteDataSource>()),
    );
    gh.lazySingleton<_i943.AddMaterialsWorkOrderCubit>(
      () => _i943.AddMaterialsWorkOrderCubit(
        addMaterialsWorkOrderUseCase: gh<_i985.AddMaterialWorkOrderUseCase>(),
      ),
    );
    gh.lazySingleton<_i605.GetUsersUseCase>(
      () => _i605.GetUsersUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.GetUserByIdUseCase>(
      () => _i605.GetUserByIdUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.FindByUsernameUseCase>(
      () => _i605.FindByUsernameUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.FindByEmailUseCase>(
      () => _i605.FindByEmailUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.FindByUsernameOrEmailUseCase>(
      () => _i605.FindByUsernameOrEmailUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.FindByRefreshTokenUseCase>(
      () => _i605.FindByRefreshTokenUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.FindEmployeeByIdCardUseCase>(
      () => _i605.FindEmployeeByIdCardUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.GetProfileUseCase>(
      () => _i605.GetProfileUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.GetUserDetailUseCase>(
      () => _i605.GetUserDetailUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.GetCustomerProfileUseCase>(
      () => _i605.GetCustomerProfileUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.FindTechniciansUseCase>(
      () => _i605.FindTechniciansUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.VerifyCredentialsUseCase>(
      () => _i605.VerifyCredentialsUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.ExistsByUsernameUseCase>(
      () => _i605.ExistsByUsernameUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.ExistsByEmailUseCase>(
      () => _i605.ExistsByEmailUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.ExistsByUsernameOrEmailUseCase>(
      () => _i605.ExistsByUsernameOrEmailUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.CreateUserUseCase>(
      () => _i605.CreateUserUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.UpdateUserUseCase>(
      () => _i605.UpdateUserUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.ChangeUserPasswordUseCase>(
      () => _i605.ChangeUserPasswordUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.DeleteUserUseCase>(
      () => _i605.DeleteUserUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.RestoreUserUseCase>(
      () => _i605.RestoreUserUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.ResetFailedAttemptsUseCase>(
      () => _i605.ResetFailedAttemptsUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.IncrementFailedAttemptsUseCase>(
      () => _i605.IncrementFailedAttemptsUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.AssignRoleToUserUseCase>(
      () => _i605.AssignRoleToUserUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.RemoveRoleFromUserUseCase>(
      () => _i605.RemoveRoleFromUserUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.AssignPermissionToUserUseCase>(
      () => _i605.AssignPermissionToUserUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.RemovePermissionFromUserUseCase>(
      () => _i605.RemovePermissionFromUserUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.GetRolesByUserUseCase>(
      () => _i605.GetRolesByUserUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.GetPermissionsByUserUseCase>(
      () => _i605.GetPermissionsByUserUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.GetUsersByRoleUseCase>(
      () => _i605.GetUsersByRoleUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i605.GetUsersByPermissionUseCase>(
      () => _i605.GetUsersByPermissionUseCase(gh<_i486.UserRepository>()),
    );
    gh.lazySingleton<_i123.LoginCubitUseCases>(
      () => _i123.LoginCubitUseCases(
        login: gh<_i68.LoginUseCase>(),
        saveUserData: gh<_i661.SaveUserDataUseCase>(),
      ),
    );
    gh.lazySingleton<_i671.GetDashboardStatsUseCase>(
      () => _i671.GetDashboardStatsUseCase(gh<_i353.DashboardRepository>()),
    );
    gh.lazySingleton<_i749.WatchDashboardStatsUseCase>(
      () => _i749.WatchDashboardStatsUseCase(gh<_i353.DashboardRepository>()),
    );
    gh.lazySingleton<_i780.CreateWorkOrderUseCase>(
      () => _i780.CreateWorkOrderUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i817.GetAllWorkOrdersUseCase>(
      () => _i817.GetAllWorkOrdersUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i119.CreateWorkOrderFromIncidentUseCase>(
      () => _i119.CreateWorkOrderFromIncidentUseCase(
        gh<_i464.WorkOrderRepository>(),
      ),
    );
    gh.lazySingleton<_i835.GetWorkOrderDetailUseCase>(
      () => _i835.GetWorkOrderDetailUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i241.GetWorkOrderTrackingUseCase>(
      () => _i241.GetWorkOrderTrackingUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i56.ReceiveWorkOrderUseCase>(
      () => _i56.ReceiveWorkOrderUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i56.AssignWorkOrderToCrewUseCase>(
      () => _i56.AssignWorkOrderToCrewUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i56.AssignWorkOrderToWorkerUseCase>(
      () =>
          _i56.AssignWorkOrderToWorkerUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i56.StartPreparationUseCase>(
      () => _i56.StartPreparationUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i56.CreatePreparationInspectionUseCase>(
      () => _i56.CreatePreparationInspectionUseCase(
        gh<_i464.WorkOrderRepository>(),
      ),
    );
    gh.lazySingleton<_i56.ResolvePreparationInspectionUseCase>(
      () => _i56.ResolvePreparationInspectionUseCase(
        gh<_i464.WorkOrderRepository>(),
      ),
    );
    gh.lazySingleton<_i56.StartExecutionUseCase>(
      () => _i56.StartExecutionUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i56.FinishExecutionUseCase>(
      () => _i56.FinishExecutionUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i56.AddWorkersBatchToWorkOrderUseCase>(
      () => _i56.AddWorkersBatchToWorkOrderUseCase(
        gh<_i464.WorkOrderRepository>(),
      ),
    );
    gh.lazySingleton<_i56.RemoveWorkerFromWorkOrderUseCase>(
      () => _i56.RemoveWorkerFromWorkOrderUseCase(
        gh<_i464.WorkOrderRepository>(),
      ),
    );
    gh.lazySingleton<_i56.AddWorkOrderMaterialsBatchUseCase>(
      () => _i56.AddWorkOrderMaterialsBatchUseCase(
        gh<_i464.WorkOrderRepository>(),
      ),
    );
    gh.lazySingleton<_i56.AddAdditionalCostsBatchUseCase>(
      () =>
          _i56.AddAdditionalCostsBatchUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i56.UploadWorkOrderAttachmentsUseCase>(
      () => _i56.UploadWorkOrderAttachmentsUseCase(
        gh<_i464.WorkOrderRepository>(),
      ),
    );
    gh.lazySingleton<_i56.CreateQualityControlUseCase>(
      () => _i56.CreateQualityControlUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i56.CompleteWorkOrderUseCase>(
      () => _i56.CompleteWorkOrderUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.lazySingleton<_i56.RegisterSatisfactionSurveyUseCase>(
      () => _i56.RegisterSatisfactionSurveyUseCase(
        gh<_i464.WorkOrderRepository>(),
      ),
    );
    gh.lazySingleton<_i56.AdvanceWorkOrderStateUseCase>(
      () => _i56.AdvanceWorkOrderStateUseCase(gh<_i464.WorkOrderRepository>()),
    );
    gh.factory<_i22.SearchConnectionCubit>(
      () => _i22.SearchConnectionCubit(gh<_i453.GetConnection>()),
    );
    gh.lazySingleton<_i12.AddWorkOrderAttachmentUseCase>(
      () => _i12.AddWorkOrderAttachmentUseCase(
        gh<_i386.AddWorkOrderAttachmentRepository>(),
      ),
    );
    gh.lazySingleton<_i788.GetAllConnectionsUseCase>(
      () => _i788.GetAllConnectionsUseCase(gh<_i459.ConnectionRepository>()),
    );
    gh.factory<_i453.GetConnectionWithProperties>(
      () => _i453.GetConnectionWithProperties(
        gh<_i1032.ConnectionWithPropertiesRepository>(),
      ),
    );
    gh.factory<_i278.DashboardCubit>(
      () => _i278.DashboardCubit(useCases: gh<_i134.DashboardCubitUseCases>()),
    );
    gh.lazySingleton<_i750.ChangePasswordUseCase>(
      () =>
          _i750.ChangePasswordUseCase(repository: gh<_i1003.AuthRepository>()),
    );
    gh.lazySingleton<_i426.LogoutUseCase>(
      () => _i426.LogoutUseCase(repository: gh<_i1003.AuthRepository>()),
    );
    gh.lazySingleton<_i144.RefreshTokenUseCase>(
      () => _i144.RefreshTokenUseCase(repository: gh<_i1003.AuthRepository>()),
    );
    gh.lazySingleton<_i13.VerifyUserUseCase>(
      () => _i13.VerifyUserUseCase(repository: gh<_i1003.AuthRepository>()),
    );
    gh.factory<_i707.WorkOrderProcessCubit>(
      () => _i707.WorkOrderProcessCubit(
        getWorkOrderDetailUseCase: gh<_i835.GetWorkOrderDetailUseCase>(),
        getWorkOrderTrackingUseCase: gh<_i241.GetWorkOrderTrackingUseCase>(),
        receiveWorkOrderUseCase: gh<_i56.ReceiveWorkOrderUseCase>(),
        assignWorkOrderToCrewUseCase: gh<_i56.AssignWorkOrderToCrewUseCase>(),
        assignWorkOrderToWorkerUseCase:
            gh<_i56.AssignWorkOrderToWorkerUseCase>(),
        startPreparationUseCase: gh<_i56.StartPreparationUseCase>(),
        createPreparationInspectionUseCase:
            gh<_i56.CreatePreparationInspectionUseCase>(),
        resolvePreparationInspectionUseCase:
            gh<_i56.ResolvePreparationInspectionUseCase>(),
        startExecutionUseCase: gh<_i56.StartExecutionUseCase>(),
        finishExecutionUseCase: gh<_i56.FinishExecutionUseCase>(),
        addWorkersBatchToWorkOrderUseCase:
            gh<_i56.AddWorkersBatchToWorkOrderUseCase>(),
        removeWorkerFromWorkOrderUseCase:
            gh<_i56.RemoveWorkerFromWorkOrderUseCase>(),
        addWorkOrderMaterialsBatchUseCase:
            gh<_i56.AddWorkOrderMaterialsBatchUseCase>(),
        addAdditionalCostsBatchUseCase:
            gh<_i56.AddAdditionalCostsBatchUseCase>(),
        uploadWorkOrderAttachmentsUseCase:
            gh<_i56.UploadWorkOrderAttachmentsUseCase>(),
        createQualityControlUseCase: gh<_i56.CreateQualityControlUseCase>(),
        completeWorkOrderUseCase: gh<_i56.CompleteWorkOrderUseCase>(),
        registerSatisfactionSurveyUseCase:
            gh<_i56.RegisterSatisfactionSurveyUseCase>(),
      ),
    );
    gh.factory<_i303.ChangePasswordCubit>(
      () => _i303.ChangePasswordCubit(
        changePasswordUseCase: gh<_i750.ChangePasswordUseCase>(),
      ),
    );
    gh.factory<_i841.CreateWorkOrderCubit>(
      () => _i841.CreateWorkOrderCubit(
        createWorkOrderUseCase: gh<_i780.CreateWorkOrderUseCase>(),
      ),
    );
    gh.lazySingleton<_i964.PreviewFileUseCase>(
      () => _i964.PreviewFileUseCase(gh<_i876.FileRepository>()),
    );
    gh.lazySingleton<_i964.DownloadFileUseCase>(
      () => _i964.DownloadFileUseCase(gh<_i876.FileRepository>()),
    );
    gh.factory<_i912.LoginCubit>(
      () => _i912.LoginCubit(
        sessionService: gh<_i497.SessionService>(),
        useCases: gh<_i123.LoginCubitUseCases>(),
      ),
    );
    gh.factory<_i372.ManuallyConnectionWithPropertiesBloc>(
      () => _i372.ManuallyConnectionWithPropertiesBloc(
        gh<_i453.GetConnectionWithProperties>(),
      ),
    );
    gh.factory<_i981.ConnectionWithPropertiesBloc>(
      () => _i981.ConnectionWithPropertiesBloc(
        gh<_i453.GetConnectionWithProperties>(),
      ),
    );
    return this;
  }
}

class _$ApiServiceModule extends _i885.ApiServiceModule {}

class _$LocalDatabaseServiceModule extends _i87.LocalDatabaseServiceModule {}

class _$HttpModule extends _i515.HttpModule {}

class _$ImagePickerServiceModule extends _i257.ImagePickerServiceModule {}

class _$InternetServiceModule extends _i662.InternetServiceModule {}

class _$NavigationServiceModule extends _i1005.NavigationServiceModule {}
