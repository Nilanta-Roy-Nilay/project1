import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? '859467709859-nm0s3dgdvobkiqfia1e7abmmkoehslkl.apps.googleusercontent.com' : null,
  );

  // Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Force creation of user document if it doesn't exist
        await _firestore.collection('users').doc(user.uid).set({
          'name': user.displayName ?? 'Google User',
          'email': user.email,
          'lastLogin': FieldValue.serverTimestamp(),
          'photoUrl': user.photoURL ?? '',
          'status': 'online',
          'dietPreference': 'standard',
          'workoutCount': 0,
          'dietDays': 0,
        }, SetOptions(merge: true)); // Use merge to avoid overwriting existing data
        return user;
      }
      return null;
    } catch (e) {
      if (e.toString().contains('10')) {
        throw 'Google Sign-In Error: Please ensure SHA-1 fingerprint is added to Firebase Console and google-services.json is up to date.';
      }
      throw e.toString();
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUp(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'photoUrl': '',
        'status': 'online',
        'dietPreference': 'standard',
        'workoutCount': 0,
        'dietDays': 0,
      });

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'status': 'online',
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'status': 'offline',
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is email verified
  bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Resend verification email
  Future<void> resendVerificationEmail() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  // Delete user account
  Future<void> deleteAccount(String password) async {
    final user = _auth.currentUser;
    if (user == null) throw 'No user logged in';
    
    final email = user.email;
    if (email == null) throw 'User email not found';

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
    await _firestore.collection('users').doc(user.uid).delete();
    await user.delete();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled in Firebase Console.';
      case 'channel-error':
        return 'Internal error. Please restart the app.';
      default:
        return 'Error (${e.code}): ${e.message ?? "An error occurred. Please try again."}';
    }
  }
}
