import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const NutriChefApp());
}

class NutriChefApp extends StatelessWidget {
  const NutriChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> usuarioInicial = {
      'id': 1,
      'name': 'Chef Beymar',
    };

    return MaterialApp(
      title: 'Nutrichef',
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'ES'),
      supportedLocales: const [ Locale('es','ES'), Locale('en','US') ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(useMaterial3: true),
      home: Home(usuario: usuarioInicial), // <- aquí se instancia Home
    );
  }
}
