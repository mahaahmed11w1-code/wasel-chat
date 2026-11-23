import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'phone_auth_screen.dart';

String? firebaseInitError;

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

  @override
  Widget build(BuildContext context) {
    User? currentUser;
    if (firebaseInitError == null) {
      try {
        currentUser = FirebaseAuth.instance.currentUser;
      } catch (e) {
        firebaseInitError = e.toString();
      }
    }

    return MaterialApp(
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
                      'تعذرت تهيئة خدمة الاتصال حالياً، ولكن يمكنك متابعة المحاولة:',
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
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const PhoneAuthScreen(),
                          ),
                        );
                      },
                      child: const Text('الانتقال إلى شاشة رقم الهاتف'),
                    ),
                  ],
                ),
              ),
            )
          : currentUser != null
              ? const PhoneAuthScreen()
              : const PhoneAuthScreen(),
    );
  }
}
