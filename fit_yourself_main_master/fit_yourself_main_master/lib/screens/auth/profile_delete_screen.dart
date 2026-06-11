import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_screen.dart';

class ProfileDeleteScreen extends StatefulWidget {
  const ProfileDeleteScreen({super.key});

  @override
  State<ProfileDeleteScreen> createState() => _ProfileDeleteScreenState();
}

class _ProfileDeleteScreenState extends State<ProfileDeleteScreen> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _reauthenticate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw 'User not found. Please log in again.';
    }

    // Refresh user data from Firebase to ensure latest session info
    try {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      debugPrint("User reload failed: $e");
    }

    if (user == null) throw 'User session lost. Please log in again.';
    
    // Check if user is logged in with Google
    bool isGoogleUser = false;
    for (UserInfo profile in user.providerData) {
      if (profile.providerId == 'google.com') {
        isGoogleUser = true;
        break;
      }
    }

    if (isGoogleUser) {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb ? '859467709859-nm0s3dgdvobkiqfia1e7abmmkoehslkl.apps.googleusercontent.com' : null,
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw 'Google sign-in cancelled';
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await user.reauthenticateWithCredential(credential);
    } else {
      final password = _passwordController.text.trim();
      if (password.isEmpty) {
        throw 'Please enter your password to confirm';
      }

      // Try multiple ways to get the user's email
      String? email = user.email;
      if (email == null || email.isEmpty) {
        for (UserInfo profile in user.providerData) {
          if (profile.email != null && profile.email!.isNotEmpty) {
            email = profile.email;
            break;
          }
        }
      }

      if (email == null || email.isEmpty) {
        throw 'User email could not be determined. Please logout and login again.';
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    }
  }

  Future<void> _deleteAccount() async {
    setState(() => _isLoading = true);
    try {
      await _reauthenticate();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User session lost';

      // 1. Delete user data from Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      
      // 2. Delete chat history
      final chatRef = FirebaseFirestore.instance.collection('chats').doc(user.uid);
      final messages = await chatRef.collection('messages').get();
      for (var doc in messages.docs) {
        await doc.reference.delete();
      }
      await chatRef.delete();

      // 3. Delete Auth account
      await user.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted permanently'), backgroundColor: Colors.green),
        );
        _goToLogin();
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _disableAccount() async {
    setState(() => _isLoading = true);
    try {
      await _reauthenticate();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User session lost';

      // Mark as disabled in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'status': 'disabled',
        'disabledAt': FieldValue.serverTimestamp(),
      });

      // Sign out
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account disabled successfully'), backgroundColor: Colors.orange),
        );
        _goToLogin();
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $msg'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    bool isGoogleUser = user?.providerData.any((p) => p.providerId == 'google.com') ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Account'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.report_problem, size: 80, color: Colors.orange),
              const SizedBox(height: 20),
              const Text(
                'Security Verification',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                isGoogleUser 
                  ? 'Since you are using Google, we will ask you to sign in again to verify.' 
                  : 'Please enter your password to confirm these sensitive actions.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              
              if (!isGoogleUser)
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              
              const SizedBox(height: 40),
              
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.orange)
              else ...[
                // Disable Button
                ElevatedButton.icon(
                  onPressed: _disableAccount,
                  icon: const Icon(Icons.block),
                  label: const Text('Temporarily Disable Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Delete Button
                ElevatedButton.icon(
                  onPressed: () => _showDeleteDialog(),
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Permanently Delete Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Are you absolutely sure?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will permanently delete your profile, workout history, and diet plans. This action is irreversible.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Delete Everything'),
          ),
        ],
      ),
    );
  }
}
