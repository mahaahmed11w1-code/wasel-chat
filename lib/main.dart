import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'phone_auth_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyDJpiLXYokCPhJDJ5oinPd8noo0SBJFDzk',
      appId: '1:149081851409:android:eab0af7c54934e9dea93b0',
      messagingSenderId: '149081851409',
      projectId: 'wasel-ea314',
      storageBucket: 'wasel-ea314.firebasestorage.app',
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    initError = e.toString();
  }

  runApp(WaselChatApp(firebaseInitError: initError));
}

class WaselChatApp extends StatelessWidget {
  final String? firebaseInitError;

  const WaselChatApp({super.key, this.firebaseInitError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Wasel Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: firebaseInitError != null
          ? FirebaseErrorScreen(errorMessage: firebaseInitError!)
          : PhoneAuthScreen(
              onAuthenticated: () => const HomePlaceholderScreen(),
            ),
    );
  }
}

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wasel Chat')),
      body: const Center(
        child: Text('تم تسجيل الدخول بنجاح'),
      ),
    );
  }
}

class FirebaseErrorScreen extends StatelessWidget {
  final String errorMessage;

  const FirebaseErrorScreen({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Initialization Error')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SelectableText(
            errorMessage,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
