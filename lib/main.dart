import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:myapp/chef/home_chef.dart'; // ajusta a tu pubspec.yaml

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase inicializado correctamente');
  } catch (e, stack) {
    print('ERROR al inicializar Firebase: $e');
    print('Stack trace: $stack');
  }

  runApp(const NutriChefApp());
}

class NutriChefApp extends StatelessWidget {
  const NutriChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrichef',
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      // <- IMPORTANTE: nombres correctos y exactos
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFFF8C21),
          primary: Color(0xFFFF8C21),
          secondary: Color(0xFFFFD54F),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),

      home: const HomeChef(
        nombreChef: "Chef Beymar",
        chefId: 1,
      ),
    );
  }
}
