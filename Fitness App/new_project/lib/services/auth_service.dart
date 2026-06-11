import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _currentUserEmail;
  String? _currentUserName;
  String? _profileImagePath;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserEmail => _currentUserEmail;
  String? get currentUserName => _currentUserName;
  String? get profileImagePath => _profileImagePath;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthService() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _currentUserEmail = prefs.getString('currentUserEmail');
    _currentUserName = prefs.getString('currentUserName');
    _profileImagePath = prefs.getString('profile_image');
    notifyListeners();
  }

  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();

    String? existingEmail = prefs.getString('email_$email');
    if (existingEmail != null) {
      _errorMessage = 'Email already registered!';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    await prefs.setString('user_${email}_name', name);
    await prefs.setString('user_${email}_email', email);
    await prefs.setString('user_${email}_password', password);
    await prefs.setString('email_$email', email);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();

    String? savedPassword = prefs.getString('user_${email}_password');
    String? savedName = prefs.getString('user_${email}_name');

    if (savedPassword != null && savedPassword == password) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('currentUserEmail', email);
      await prefs.setString(
          'currentUserName', savedName ?? email.split('@')[0]);

      _isLoggedIn = true;
      _currentUserEmail = email;
      _currentUserName = savedName ?? email.split('@')[0];
      _profileImagePath = prefs.getString('profile_image');

      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Save profile image
  Future<void> saveProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);
    _profileImagePath = path;
    notifyListeners();
  }

  // Remove profile image
  Future<void> removeProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image');
    _profileImagePath = null;
    notifyListeners();
  }

  // Update profile name
  Future<void> updateProfileName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUserEmail != null) {
      await prefs.setString('user_${_currentUserEmail}_name', name);
      await prefs.setString('currentUserName', name);
      _currentUserName = name;
      notifyListeners();
    }
  }

  // Update profile email
  Future<void> updateProfileEmail(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUserEmail != null) {
      String? savedPassword =
          prefs.getString('user_${_currentUserEmail}_password');

      if (savedPassword == password) {
        String? userName = prefs.getString('user_${_currentUserEmail}_name');

        await prefs.remove('email_$_currentUserEmail');

        await prefs.setString('user_${email}_name', userName ?? 'User');
        await prefs.setString('user_${email}_email', email);
        await prefs.setString('user_${email}_password', savedPassword!);
        await prefs.setString('email_$email', email);
        await prefs.setString('currentUserEmail', email);

        _currentUserEmail = email;
        notifyListeners();
      }
    }
  }

  // Forgot password
  Future<bool> sendPasswordReset(String email) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    String? existingEmail = prefs.getString('email_$email');

    _isLoading = false;
    notifyListeners();

    return existingEmail != null;
  }

  // Reset password
  Future<bool> resetPassword(String email, String newPassword) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_${email}_password', newPassword);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('currentUserEmail');
    await prefs.remove('currentUserName');

    _isLoggedIn = false;
    _currentUserEmail = null;
    _currentUserName = null;
    _profileImagePath = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
