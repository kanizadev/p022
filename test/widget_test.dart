import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:p022/main.dart';
import 'package:p022/screens/home_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Widget Tests', () {
    testWidgets('App launches and shows HomeScreen with correct structure',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.pump();

      expect(find.text('SQLite Users'), findsOneWidget);

      expect(find.byIcon(Icons.add), findsOneWidget);

      expect(find.byType(AppBar), findsOneWidget);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('HomeScreen has correct UI components',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      await tester.pump();

      expect(find.text('SQLite Users'), findsOneWidget);

      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      expect(tester.widget<FloatingActionButton>(fab).onPressed, isNotNull);

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('MyApp widget builds correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.pump();

      expect(find.byType(MaterialApp), findsOneWidget);

      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
