import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  final String name;
  final String dietPreference;
  final String photoUrl;
  final Map<String, dynamic> extraData;

  const ProfileEditScreen({
    super.key,
    required this.name,
    required this.dietPreference,
    required this.photoUrl,
    this.extraData = const {},
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _photoUrlController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;
  late String _dietPreference;
  late String _fitnessGoal;
  bool _isLoading = false;
  String? _localImagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _photoUrlController = TextEditingController(text: widget.photoUrl);
    _heightController = TextEditingController(text: widget.extraData['height']?.toString() ?? '');
    _weightController = TextEditingController(text: widget.extraData['weight']?.toString() ?? '');
    _ageController = TextEditingController(text: widget.extraData['age']?.toString() ?? '');
    _dietPreference = widget.dietPreference;
    _fitnessGoal = widget.extraData['fitnessGoal'] ?? 'Stay fit';
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _localImagePath = image.path;
        _photoUrlController.text = image.path;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      
      // Save all data including photoUrl
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': _nameController.text.trim(),
        'dietPreference': _dietPreference,
        'photoUrl': _photoUrlController.text.trim(),
        'height': double.tryParse(_heightController.text.trim()) ?? 0,
        'weight': double.tryParse(_weightController.text.trim()) ?? 0,
        'age': int.tryParse(_ageController.text.trim()) ?? 0,
        'fitnessGoal': _fitnessGoal,
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.orange,
                      backgroundImage: _buildPreviewImage(),
                      child: _photoUrlController.text.isEmpty && _localImagePath == null
                          ? const Icon(Icons.camera_alt, color: Colors.white, size: 30)
                          : null,
                    ),
                    if (_photoUrlController.text.isNotEmpty || _localImagePath != null)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _localImagePath = null;
                              _photoUrlController.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.delete, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: _pickImage, child: const Text('Change Photo', style: TextStyle(color: Colors.orange))),
              const SizedBox(height: 16),
              _buildTextField(_nameController, 'Full Name', Icons.person),
              const SizedBox(height: 16),
              _buildTextField(_photoUrlController, 'Profile Image URL / Path', Icons.link),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField(_heightController, 'Height (cm)', Icons.height, keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(_weightController, 'Weight (kg)', Icons.monitor_weight, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(_ageController, 'Age', Icons.calendar_today, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildDropdown('Diet Preference', _dietPreference, ['standard', 'vegetarian', 'vegan', 'keto'], (val) => setState(() => _dietPreference = val!)),
              const SizedBox(height: 16),
              _buildDropdown('Fitness Goal', _fitnessGoal, ['Lose weight', 'Build muscle', 'Stay fit', 'Increase stamina'], (val) => setState(() => _fitnessGoal = val!)),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Save Changes', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _buildPreviewImage() {
    if (_localImagePath != null) {
      return kIsWeb ? NetworkImage(_localImagePath!) : FileImage(File(_localImagePath!)) as ImageProvider;
    }
    if (_photoUrlController.text.isNotEmpty) {
      if (_photoUrlController.text.startsWith('http') || _photoUrlController.text.startsWith('blob:') || kIsWeb) {
        return NetworkImage(_photoUrlController.text);
      } else {
        return FileImage(File(_photoUrlController.text));
      }
    }
    return null;
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {String? hint, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.orange),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF1A1A2E),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.star, color: Colors.orange),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase()))).toList(),
      onChanged: onChanged,
    );
  }
}
