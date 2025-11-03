// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('NutriChef app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NutriChefApp());

    // Verify that our welcome message is displayed.
    expect(find.text('¡Hola Nutrichefcitos!'), findsOneWidget);
    
    // Verify that the subtitle is displayed.
    expect(find.text('Tu compañero perfecto para una vida saludable'), findsOneWidget);

    // Verify that the "Comenzar" button exists.
    expect(find.text('Comenzar'), findsOneWidget);
    
    // Verify that feature cards are displayed.
    expect(find.text('Recetas'), findsOneWidget);
    expect(find.text('Favoritos'), findsOneWidget);
    expect(find.text('Plan Semanal'), findsOneWidget);
    expect(find.text('Lista de Compras'), findsOneWidget);
  });

  testWidgets('NutriChef button tap test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NutriChefApp());

    // Find the "Comenzar" button.
    final comenzarButton = find.text('Comenzar');
    
    // Verify the button exists.
    expect(comenzarButton, findsOneWidget);
    
    // Tap the button (aunque no hace nada por ahora).
    await tester.tap(comenzarButton);
    await tester.pump();
  });
}