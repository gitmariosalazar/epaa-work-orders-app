import 'package:clean_architecture/shared_ui/themes/theme.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/domain/entities/user.dart';
import 'package:clean_architecture/core/services/image_picker/image_picker_service.dart';
import 'package:clean_architecture/core/services/navigation/navigation_service.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/login_use_case.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/save_user_data_use_case.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit_use_cases.dart';
import 'package:clean_architecture/features/auth/presentation/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrol/patrol.dart';

import 'package:clean_architecture/shared_ui/cubits/screen_observer/screen_observer_cubit.dart';
import '../../../../../testing/mocks/cubit_mocks.dart';
import '../../../../../testing/mocks/external/router_mocks.dart';
import '../../../../../testing/mocks/service_mocks.dart';
import '../../../../../testing/mocks/use_case_mocks.dart';

final locator = GetIt.I;

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSaveUserDataUseCase mockSaveUserDataUseCase;
  late MockSessionService mockSessionService;
  late MockNavigationService mockNavigationService;
  late MockImagePickerService mockImagePickerService;
  late MockScreenObserverCubit mockScreenObserverCubit;
  late UserData userData;

  setUpAll(() {
    userData = UserData(
      user: User(
        userId: "0",
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        roles: const [],
        permissions: const [],
        isActive: true,
      ),
      accessToken: '',
      refreshToken: '',
    );
    registerFallbackValue(const Authentication(username: '', password: ''));
    registerFallbackValue(MockPageRouteInfo());
    registerFallbackValue(userData);
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSaveUserDataUseCase = MockSaveUserDataUseCase();
    mockSessionService = MockSessionService();
    mockNavigationService = MockNavigationService();
    mockImagePickerService = MockImagePickerService();
    mockScreenObserverCubit = MockScreenObserverCubit();

    when(
      () => mockScreenObserverCubit.state,
    ).thenReturn(ScreenObserverState.initial());

    locator.registerSingleton<LoginUseCase>(mockLoginUseCase);
    locator.registerSingleton<SaveUserDataUseCase>(mockSaveUserDataUseCase);
    locator.registerSingleton<SessionService>(mockSessionService);
    locator.registerSingleton<NavigationService>(mockNavigationService);
    locator.registerSingleton<ImagePickerService>(mockImagePickerService);
    locator.registerFactory<LoginCubit>(
      () => LoginCubit(
        sessionService: GetIt.I<SessionService>(),
        useCases: LoginCubitUseCases(
          login: mockLoginUseCase,
          saveUserData: mockSaveUserDataUseCase,
        ),
      ),
    );
    final screenDetails = ScreenDetails(
      logicalSize: Size(1030, 1280),
      physicalSize: Size(1030, 1280),
      devicePixelRatio: 1,
    );
    ScreenUtil.I.configureScreen(screenDetails);
  });

  tearDown(() {
    locator.reset();
  });

  patrolWidgetTest("Login and save the user credential", ($) async {
    // Arrange
    when(
      () => mockSessionService.setUserData = userData,
    ).thenAnswer((_) => userData);
    when(
      () => mockNavigationService.replaceAllRoute(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockLoginUseCase.call(any()),
    ).thenAnswer((_) async => SuccessState(data: userData));
    when(
      () => mockSaveUserDataUseCase.call(any()),
    ).thenAnswer((_) async => SuccessState(data: true));

    // Render the view
    await $.pumpWidget(
      MaterialApp(
        theme: lightTheme,
        home: BlocProvider<ScreenObserverCubit>.value(
          value: mockScreenObserverCubit,
          child: const LoginPage(),
        ),
      ),
    );

    // Expect the login button to be enabled initially
    expect($("INICIAR SESIÓN"), findsOne);
    expect($("Enter your password"), findsOne);
    final enabledButton = $(
      ElevatedButton,
    ).which<ElevatedButton>((b) => b.enabled);
    expect(enabledButton, findsOneWidget);
    expect($(TextButton), findsOneWidget);
    expect($(InkWell).$(Icons.visibility_off_outlined), findsOneWidget);

    // Enter email and password
    await $(TextField).at(0).enterText("username");
    await $(TextField).at(1).enterText("password");

    await $(Checkbox).tap();

    // Use the login cubit's login method in the login_button widget.
    // Otherwise the test will fail.
    await enabledButton.scrollTo().tap();

    verify(() => mockLoginUseCase.call(any())).called(1);
    verify(() => mockSessionService.setUserData = any()).called(1);
    verify(() => mockNavigationService.replaceAllRoute(any())).called(1);
  });
}
