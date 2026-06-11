// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';

class YogaSessionScreen extends StatefulWidget {
  const YogaSessionScreen({super.key});

  @override
  State<YogaSessionScreen> createState() => _YogaSessionScreenState();
}

class _YogaSessionScreenState extends State<YogaSessionScreen> {
  Timer? _timer;
  int _duration = 0;
  bool _isRunning = false;
  int _currentPoseIndex = 0;

  final List<String> _poses = [
    'Mountain Pose',
    'Warrior I',
    'Warrior II',
    'Downward Dog',
    'Child\'s Pose',
    'Corpse Pose',
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration++;
        _updatePose();
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isRunning = false;
    });
  }

  void _updatePose() {
    int poseIndex = (_duration ~/ 30) % _poses.length;
    if (poseIndex != _currentPoseIndex) {
      _currentPoseIndex = poseIndex;
      // Haptic feedback for pose change
    }
  }

  Future<void> _finishSession() async {
    _timer?.cancel();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _duration ~/ 60;
    int seconds = _duration % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Session'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF4CAF50).withOpacity(0.1), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Current Pose',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _poses[_currentPoseIndex],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ..._poses.asMap().entries.map((entry) {
                      int index = entry.key;
                      String pose = entry.value;
                      bool isActive = index == _currentPoseIndex;
                      bool isCompleted = index < _currentPoseIndex;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              isCompleted
                                  ? Icons.check_circle
                                  : isActive
                                      ? Icons.play_circle
                                      : Icons.radio_button_unchecked,
                              color: isCompleted
                                  ? Colors.green
                                  : isActive
                                      ? const Color(0xFF4CAF50)
                                      : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              pose,
                              style: TextStyle(
                                color: isCompleted
                                    ? Colors.green
                                    : isActive
                                        ? Colors.black
                                        : Colors.grey,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    backgroundColor: _isRunning ? Colors.orange : Colors.green,
                    child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: _finishSession,
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.stop),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
