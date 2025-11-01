import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Sign Up Learner (with detailed debug info)
  Future<User?> signUpLearner({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      log('🟢 Attempting learner sign-up for $email');
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      log('✅ Firebase user created: ${user?.uid}');

      await _firestore.collection('users').doc(user!.uid).set({
        'role': 'learner',
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      log('✅ Firestore user document created for ${user.uid}');
      return user;

    } on FirebaseAuthException catch (e, stack) {
      log('❌ FirebaseAuthException');
      log('Code: ${e.code}');
      log('Message: ${e.message}');
      log('Stacktrace: $stack');

      throw Exception('FirebaseAuth Error: ${e.code} - ${e.message}');
    } catch (e, stack) {
      log('💥 Unknown Exception during learner sign-up: $e');
      log('Stacktrace: $stack');
      throw Exception('Unexpected error: $e');
    }
  }

  /// 🔹 Sign Up Mentor
  Future<User?> signUpMentor({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required List<String> expertise,
  }) async {
    try {
      log('🟢 Attempting mentor sign-up for $email');
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      log('✅ Firebase mentor user created: ${user?.uid}');

      await _firestore.collection('mentors').doc(user!.uid).set({
        'role': 'mentor',
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'expertise': expertise.where((e) => e.isNotEmpty).toList(),
        'approved': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      log('✅ Firestore mentor document created for ${user.uid}');
      return user;

    } on FirebaseAuthException catch (e, stack) {
      log('❌ FirebaseAuthException');
      log('Code: ${e.code}');
      log('Message: ${e.message}');
      log('Stacktrace: $stack');
      throw Exception('FirebaseAuth Error: ${e.code} - ${e.message}');
    } catch (e, stack) {
      log('💥 Unknown Exception during mentor sign-up: $e');
      log('Stacktrace: $stack');
      throw Exception('Unexpected error: $e');
    }
  }

  /// 🔹 Login
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      log('🟢 Attempting login for $email');
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      log('✅ Login success for ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e, stack) {
      log('❌ FirebaseAuthException');
      log('Code: ${e.code}');
      log('Message: ${e.message}');
      log('Stacktrace: $stack');
      throw Exception('FirebaseAuth Error: ${e.code} - ${e.message}');
    } catch (e, stack) {
      log('💥 Unknown Exception during login: $e');
      log('Stacktrace: $stack');
      throw Exception('Unexpected error: $e');
    }
  }

  /// 🔹 Logout
  Future<void> signOut() async => await _auth.signOut();

  /// 🔹 Current user
  User? get currentUser => _auth.currentUser;
}
