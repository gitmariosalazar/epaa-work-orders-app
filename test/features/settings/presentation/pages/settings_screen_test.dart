import 'package:clean_architecture/core/domain/entities/user.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/settings/presentation/pages/settings_screen.dart';
import 'package:clean_architecture/features/theme/presentation/cubits/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionService extends Mock implements SessionService {}

class MockThemeCubit extends Mock implements ThemeCubit {}

void main() {
  late MockSessionService mockSession;
  late MockThemeCubit mockThemeCubit;

  setUp(() {
    mockSession = MockSessionService();
    mockThemeCubit = MockThemeCubit();

    when(() => mockSession.isLoggedIn).thenReturn(true);
    when(() => mockSession.userData).thenReturn(
      UserData(
        user: User(
          userId: '1',
          firstName: 'Mario',
          lastName: 'Salazar',
          username: 'msalazar',
          email: 'mario@epaa.com',
          roles: const [],
          permissions: const [],
          isActive: true,
        ),
        accessToken: 'token',
        refreshToken: 'refresh',
      ),
    );
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<ThemeCubit>.value(
        value: mockThemeCubit,
        child: SettingsScreen(session: mockSession),
      ),
    );
  }

  testWidgets('renders SettingsScreen with Modo claro switch when theme is light', (tester) async {
    when(() => mockThemeCubit.state).thenReturn(ThemeMode.light);
    when(() => mockThemeCubit.isDark).thenReturn(false);
    when(() => mockThemeCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Configuración'), findsOneWidget);
    expect(find.text('Modo claro'), findsOneWidget);
    expect(find.text('Interfaz en tono claro'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNWidgets(2)); // Theme switch + Notifications switch
  });

  testWidgets('renders SettingsScreen with Modo oscuro switch when theme is dark', (tester) async {
    when(() => mockThemeCubit.state).thenReturn(ThemeMode.dark);
    when(() => mockThemeCubit.isDark).thenReturn(true);
    when(() => mockThemeCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Modo oscuro'), findsOneWidget);
    expect(find.text('Interfaz en tono oscuro'), findsOneWidget);
  });

  testWidgets('taps theme switch and calls toggleTheme on ThemeCubit', (tester) async {
    when(() => mockThemeCubit.state).thenReturn(ThemeMode.light);
    when(() => mockThemeCubit.isDark).thenReturn(false);
    when(() => mockThemeCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockThemeCubit.toggleTheme()).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget());

    final themeSwitch = find.widgetWithText(SwitchListTile, 'Modo claro');
    expect(themeSwitch, findsOneWidget);

    await tester.tap(themeSwitch);
    await tester.pumpAndSettle();

    verify(() => mockThemeCubit.toggleTheme()).called(1);
  });
}
