import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart' as app_auth;
import 'providers/listings_provider.dart';
import 'providers/swaps_provider.dart';
import 'providers/user_settings_provider.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => ListingsProvider()),
        ChangeNotifierProvider(create: (_) => SwapsProvider()),
        ChangeNotifierProvider(create: (_) => UserSettingsProvider()),
      ],
      child: MaterialApp(
        title: 'BookSwap',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFFD166),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF1A1B2E),
          useMaterial3: true,
        ),
        home: const Root(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<app_auth.AuthProvider>(context);

    // Show loading spinner while checking auth state
    if (auth.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1B2E),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFFD166),
          ),
        ),
      );
    }

    // Navigate based on auth state
    return auth.isSignedIn ? const HomeScreen() : const SignInScreen();
  }
}