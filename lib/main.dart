import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'phone_auth_screen.dart';

String? firebaseInitError;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    firebaseInitError = e.toString();
  }
  runApp(const WaselChatApp());
}

class WaselChatApp extends StatelessWidget {
  const WaselChatApp({super.key});

  Widget _buildPhoneAuthScreen() {
    return PhoneAuthScreen(
      onAuthenticated: const Scaffold(
        body: Center(
          child: Text('تم التحقق من رقم الهاتف بنجاح'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'wasel_chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: firebaseInitError != null
          ? Scaffold(
              appBar: AppBar(title: const Text('wasel_chat')),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'تعذرت تهيئة خدمة الاتصال حالياً:',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      firebaseInitError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        navigatorKey.currentState?.pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => _buildPhoneAuthScreen(),
                          ),
                        );
                      },
                      child: const Text('الانتقال إلى شاشة رقم الهاتف'),
                    ),
                  ],
                ),
              ),
            )
          : _buildPhoneAuthScreen(),
    );
  }
}
