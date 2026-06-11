import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../main_navigation.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  final String email;
  const TwoFactorAuthScreen({super.key, required this.email});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String? _verificationId;
  bool _isLoading = false;
  bool _otpSent = false;
  ConfirmationResult? _webConfirmationResult;
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    // Disable reCAPTCHA for testing purposes
    _auth.setSettings(appVerificationDisabledForTesting: true);
  }

  Future<void> _sendOTP() async {
    if (_isLoading) return; // Prevent multiple clicks
    
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || !phone.startsWith('+')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter phone with country code (e.g. +8801...)')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _isBlocked = false;
    });

    try {
      if (kIsWeb) {
        // signInWithPhoneNumber automatically handles the reCAPTCHA on Web
        _webConfirmationResult = await _auth.signInWithPhoneNumber(phone);
        setState(() {
          _otpSent = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification code sent!')));
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.currentUser?.linkWithCredential(credential);
            _navigateToHome();
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              _isLoading = false;
              if (e.code == 'too-many-requests') _isBlocked = true;
            });
            _showError(e.message ?? "Verification Failed");
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _verificationId = verificationId;
              _otpSent = true;
              _isLoading = false;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        if (e.toString().contains('too-many-requests')) _isBlocked = true;
      });
      _showError("Failed to send SMS. If you're blocked, try adding this number as a 'Test Number' in Firebase Console.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _verifyOTP() async {
    final code = _otpController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      if (kIsWeb && _webConfirmationResult != null) {
        UserCredential userCredential = await _webConfirmationResult!.confirm(code);
        if (userCredential.user != null) _navigateToHome();
      } else if (_verificationId != null) {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: code,
        );
        
        try {
          // Try linking to the current account (e.g. adding 2FA to Email login)
          if (_auth.currentUser != null) {
            await _auth.currentUser!.linkWithCredential(credential);
          } else {
            // If no user is logged in, just sign in with the phone
            await _auth.signInWithCredential(credential);
          }
        } catch (linkError) {
          // If phone is already linked to another account, sign in with that account instead
          if (linkError is FirebaseAuthException && 
              (linkError.code == 'credential-already-in-use' || linkError.code == 'provider-already-linked')) {
            debugPrint("Phone already in use, signing in directly...");
            await _auth.signInWithCredential(credential);
          } else {
            rethrow;
          }
        }
        _navigateToHome();
      }
    } catch (e) {
      String errorMessage = 'Verification Failed';
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-verification-code') {
          errorMessage = 'The code you entered is incorrect. Please check the SMS again.';
        } else {
          errorMessage = e.message ?? e.code;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security Check'), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 80, color: Colors.orange),
            const SizedBox(height: 24),
            Text(
              _otpSent 
                  ? 'Enter the verification code'
                  : 'We need to verify your identity to continue',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            if (!_otpSent) ...[
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+8801XXXXXXXXX',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 16),
              if (_isBlocked)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    "You are temporarily blocked. Please add this number as a 'Test Number' in your Firebase Console to bypass this limit during development.",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _sendOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Send Code'),
                    ),
            ] else ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8, color: Colors.black),
                decoration: InputDecoration(
                  hintText: '000000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _verifyOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Verify'),
                    ),
            ],
          ],
        ),
      ),
    );
  }
}
