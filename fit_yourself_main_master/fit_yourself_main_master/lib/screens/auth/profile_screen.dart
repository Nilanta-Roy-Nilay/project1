import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import 'profile_edit_screen.dart';
import 'profile_delete_screen.dart';
import '../group_chat_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final Box _settingsBox = Hive.box('settingsBox');

  bool _isDarkMode = false;
  String _userName = '';
  String _userEmail = '';
  String _photoUrl = '';
  String _dietPreference = 'standard';
  double _height = 0;
  double _weight = 0;
  int _age = 0;
  String _fitnessGoal = 'Stay fit';
  int _workoutCount = 0;
  int _dietDays = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _isDarkMode = _settingsBox.get('darkMode', defaultValue: false) as bool;
    });
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Force refresh from server to ensure we see updates immediately
        final doc = await _firestore.collection('users').doc(user.uid).get(
          const GetOptions(source: Source.serverAndCache)
        );
        if (doc.exists) {
          final data = doc.data()!;
          if (mounted) {
            setState(() {
              _userName = data['name'] ?? 'User';
              _userEmail = user.email ?? '';
              _photoUrl = data['photoUrl'] ?? '';
              _dietPreference = data['dietPreference'] ?? 'standard';
              _height = (data['height'] as num?)?.toDouble() ?? 0;
              _weight = (data['weight'] as num?)?.toDouble() ?? 0;
              _age = (data['age'] as num?)?.toInt() ?? 0;
              _fitnessGoal = data['fitnessGoal'] ?? 'Stay fit';
              _workoutCount = data['workoutCount'] ?? 0;
              _dietDays = data['dietDays'] ?? 0;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    setState(() => _isDarkMode = value);
    await _settingsBox.put('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileImage(),
                  const SizedBox(height: 16),
                  Text(_userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(_userEmail, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Theme Settings'),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    secondary: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.orange),
                    value: _isDarkMode,
                    onChanged: _toggleDarkMode,
                  ),
                  const Divider(),
                  _buildSectionTitle('Fitness Details'),
                  _buildInfoCard(),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'Edit Profile Details',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(
                            name: _userName,
                            dietPreference: _dietPreference,
                            photoUrl: _photoUrl,
                            extraData: {
                              'height': _height,
                              'weight': _weight,
                              'age': _age,
                              'fitnessGoal': _fitnessGoal,
                            },
                          ),
                        ),
                      );
                      if (result == true) _loadUserData();
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.group,
                    label: 'Community Group Chat',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GroupChatScreen()),
                      );
                    },
                  ),
                  _buildActionButton(icon: Icons.share, label: 'Share Profile Link', onTap: _shareProfile),
                  _buildActionButton(
                    icon: Icons.delete_forever,
                    label: 'Delete Account Permanently',
                    color: Colors.red,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileDeleteScreen())),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange)),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.height, 'Height', '${_height > 0 ? _height : "--"} cm'),
            _buildInfoRow(Icons.monitor_weight, 'Weight', '${_weight > 0 ? _weight : "--"} kg'),
            _buildInfoRow(Icons.calendar_today, 'Age', '${_age > 0 ? _age : "--"} years'),
            _buildInfoRow(Icons.track_changes, 'Goal', _fitnessGoal),
            const Divider(),
            _buildInfoRow(Icons.restaurant, 'Diet', _dietPreference.toUpperCase()),
            _buildInfoRow(Icons.fitness_center, 'Workouts', '$_workoutCount completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.orange,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: ClipOval(
          child: _photoUrl.isNotEmpty
              ? (_photoUrl.startsWith('http') || _photoUrl.startsWith('blob:') || kIsWeb)
                  ? Image.network(
                      _photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 50, color: Colors.white),
                    )
                  : Image.file(
                      File(_photoUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 50, color: Colors.white),
                    )
              : const Icon(Icons.person, size: 50, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap, Color color = Colors.orange}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  void _shareProfile() {
    final profileUrl = 'https://fityourself.app/profile/${_auth.currentUser?.uid}';
    Share.share('Check out my fitness profile on Fit Yourself!\n$profileUrl');
    Clipboard.setData(ClipboardData(text: profileUrl));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile link copied!')));
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Logout')),
        ],
      ),
    );
    if (confirm == true) {
      await _auth.signOut();
      if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
    }
  }
}
