import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isJoined = false;
  bool _checkingJoinStatus = true;

  @override
  void initState() {
    super.initState();
    _checkJoinStatus();
  }

  Future<void> _checkJoinStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore
          .collection('channels')
          .doc('community_main')
          .collection('members')
          .doc(user.uid)
          .get();
      
      if (mounted) {
        setState(() {
          _isJoined = doc.exists;
          _checkingJoinStatus = false;
        });
      }
    }
  }

  Future<void> _joinChannel() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('channels')
          .doc('community_main')
          .collection('members')
          .doc(user.uid)
          .set({
        'joinedAt': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });
      setState(() => _isJoined = true);
    }
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    final userData = await _firestore.collection('users').doc(user.uid).get();
    final userName = userData.data()?['name'] ?? 'User';

    await _firestore
        .collection('channels')
        .doc('community_main')
        .collection('messages')
        .add({
      'text': _messageController.text.trim(),
      'senderId': user.uid,
      'senderName': userName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showOnlineUsers() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            
            final allUsers = snapshot.data!.docs.where((doc) => doc.id != _auth.currentUser?.uid).toList();
            
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Online Fitness Members',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      final userData = allUsers[index].data() as Map<String, dynamic>;
                      final bool isOnline = userData['status'] == 'online';
                      
                      return ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Text(userData['name']?[0] ?? 'U', style: const TextStyle(color: Colors.white)),
                            ),
                            if (isOnline)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF1A1A2E), width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(userData['name'] ?? 'User', style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                          isOnline ? 'Online' : 'Offline',
                          style: TextStyle(color: isOnline ? Colors.green : Colors.grey, fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.person_add, color: Colors.orange),
                          onPressed: () => _inviteUser(allUsers[index].id, userData['name'] ?? 'User'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _inviteUser(String userId, String userName) async {
    // Check if already a member
    final memberDoc = await _firestore
        .collection('channels')
        .doc('community_main')
        .collection('members')
        .doc(userId)
        .get();

    if (memberDoc.exists) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$userName is already in the community!')),
        );
      }
      return;
    }

    // In a real app, you'd send a request. Here we'll "Invite" them by adding them to the collection
    // and sending a system message.
    await _firestore
        .collection('channels')
        .doc('community_main')
        .collection('members')
        .doc(userId)
        .set({
      'joinedAt': FieldValue.serverTimestamp(),
      'userId': userId,
      'invitedBy': _auth.currentUser?.uid,
    });

    await _firestore
        .collection('channels')
        .doc('community_main')
        .collection('messages')
        .add({
      'text': 'system: $userName has been invited to the community by ${_auth.currentUser?.displayName ?? "a member"}.',
      'senderId': 'system',
      'senderName': 'System',
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request sent! $userName added to community.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingJoinStatus) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A2E),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isJoined) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(title: const Text('Fitness Community'), backgroundColor: Colors.orange),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.groups_3, size: 100, color: Colors.orange),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Fit Yourself Community!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Join our fitness community to share your progress, ask questions, and motivate others.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: _joinChannel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('JOIN COMMUNITY'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Online Community'),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').where('status', isEqualTo: 'online').snapshots(),
              builder: (context, snapshot) {
                int onlineCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
                return Text('$onlineCount members online', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal));
              },
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: _showOnlineUsers,
            tooltip: 'Add Online Members',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('channels')
                  .doc('community_main')
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final bool isSystem = data['senderId'] == 'system';
                    final isMe = data['senderId'] == _auth.currentUser?.uid;
                    final time = data['timestamp'] != null
                        ? DateFormat('h:mm a').format((data['timestamp'] as Timestamp).toDate())
                        : '';

                    if (isSystem) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            data['text'].toString().replaceFirst('system: ', ''),
                            style: const TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic),
                          ),
                        ),
                      );
                    }

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.orange : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
                            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              Text(
                                data['senderName'] ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            const SizedBox(height: 2),
                            Text(
                              data['text'] ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              time,
                              style: const TextStyle(color: Colors.white54, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Share your fitness journey...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
