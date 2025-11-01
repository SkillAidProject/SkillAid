import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skillaid/firebase_options.dart';

class TestFirebaseScreen extends StatefulWidget {
  const TestFirebaseScreen({super.key});

  @override
  State<TestFirebaseScreen> createState() => _TestFirebaseScreenState();
}

class _TestFirebaseScreenState extends State<TestFirebaseScreen> {
  String status = 'Connecting to Firebase...';

  @override
  void initState() {
    super.initState();
    _checkFirebase();
  }

  Future<void> _checkFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() {
        status = '✅ Firebase connected successfully!';
      });
    } catch (e) {
      setState(() {
        status = '❌ Firebase connection failed:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: Center(
        child: Text(
          status,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
