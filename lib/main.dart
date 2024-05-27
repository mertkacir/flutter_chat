
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/firebase_options.dart';
import 'package:namer_app/services/auth/auth_gate.dart';
import 'package:namer_app/services/auth/auth_service.dart';
import 'package:namer_app/themes/theme_provider.dart';

//import 'package:namer_app/services/auth/login_or_register.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: AuthGate(),
    );
  }
}