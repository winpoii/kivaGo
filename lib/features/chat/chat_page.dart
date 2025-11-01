import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/chat_service.dart';
import '../../core/models/user_model.dart';
import '../../core/models/travel_plan_model.dart';

/// Home page - AI Chat with n8n webhook integration
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  UserModel? _currentUser;
  String? _currentPlanId;
  bool _isLoading = false;
  bool _isSending = false;

  // Geçmiş sohbetler
  final List<Map<String, String>> _chatHistory = [
    {'title': 'Beach vacation ideas', 'time': '2 hours ago'},
    {'title': 'Mountain hiking spots', 'time': 'Yesterday'},
    {'title': 'City break suggestions', 'time': '2 days ago'},
    {'title': 'Romantic getaway plans', 'time': '1 week ago'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserDataAndInitializeChat();
  }

  Future<void> _loadUserDataAndInitializeChat() async {
    await _loadUserData();
    await _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      print('👤 Loading user data...');
      final user = await _authService.getCurrentUserFromFirestore();
      print('✅ User loaded: ${user?.displayName}');

      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  Future<void> _initializeChat() async {
    print('🚀 Initializing chat...');

    if (_currentUser == null) {
      print('❌ Current user is null');
      return;
    }

    print('👤 Current user: ${_currentUser!.uid}');

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if user has existing travel plans
      print('🔍 Checking existing travel plans...');
      final existingPlans =
          await _chatService.getUserTravelPlans(_currentUser!.uid);
      print('📋 Found ${existingPlans.length} existing plans');

      if (existingPlans.isNotEmpty) {
        // Use the most recent plan
        print('✅ Using existing plan: ${existingPlans.first.planId}');
        setState(() {
          _currentPlanId = existingPlans.first.planId;
        });
      } else {
        // No existing plans - will create new one when first message is sent
        print(
            '🆕 No existing plans found. Will create new one on first message.');
        setState(() {
          _currentPlanId =
              null; // Start with null - will be set after first message
        });
      }

      print('🎉 Chat initialized successfully. Plan ID: $_currentPlanId');
    } catch (e) {
      print('❌ Error initializing chat: $e');
      _showErrorSnackBar('Sohbet başlatılamadı: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      _showErrorSnackBar('Lütfen bir mesaj yazın');
      return;
    }

    if (_currentUser == null) {
      _showErrorSnackBar('Kullanıcı bilgileri yüklenemedi');
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      print('🚀 Sending message: $message');
      print('📋 Current plan ID: $_currentPlanId');

      // Send message via n8n webhook
      // If _currentPlanId is null, it will start a new conversation
      final returnedPlanId = await _chatService.sendMessage(
        userId: _currentUser!.uid,
        messageContent: message,
        planId: _currentPlanId, // Can be null for new conversations
      );

      // Update currentPlanId if this was a new conversation
      if (_currentPlanId == null) {
        print('🆕 New conversation started. Plan ID: $returnedPlanId');
        setState(() {
          _currentPlanId = returnedPlanId;
        });
      }

      // Clear input
      _messageController.clear();

      // Scroll to bottom
      _scrollToBottom();

      print('✅ Message sent successfully');
    } catch (e) {
      print('❌ Error sending message: $e');
      _showErrorSnackBar('Mesaj gönderilemedi: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'kivaGo AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C2C2C),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFC11336).withOpacity(0.1),
                  const Color(0xFFC11336).withOpacity(0.3),
                  const Color(0xFFC11336).withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC11336),
              ),
            )
          : Column(
              children: [
                // Main Chat Area
                Expanded(
                  child: _currentPlanId != null
                      ? _buildChatArea()
                      : _buildEmptyState(),
                ),

                // Message Input
                _buildMessageInput(),
              ],
            ),
    );
  }

  Widget _buildChatArea() {
    return StreamBuilder<TravelPlanModel?>(
      stream: _chatService.getTravelPlanStream(_currentPlanId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Hata: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFC11336),
            ),
          );
        }

        final travelPlan = snapshot.data!;
        final messages = travelPlan.aiConversationHistory;

        if (messages.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return _buildMessageBubble(message);
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(AiConversationItemModel message) {
    final isAI = message.role == 'ai';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isAI) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFC11336).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.smart_toy,
                size: 18,
                color: Color(0xFFC11336),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isAI ? Colors.grey[100] : const Color(0xFFC11336),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isAI ? const Color(0xFF2C2C2C) : Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (!isAI) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFC11336).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                size: 18,
                color: Color(0xFFC11336),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFC11336).withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 40,
              color: Color(0xFFC11336),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nasıl hissetmek istersin?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sana özel seyahat deneyimi tasarlayalım',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Mesajınızı yazın...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: const Color(0xFFC11336).withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: Color(0xFFC11336),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isSending
                  ? const Color(0xFFC11336).withOpacity(0.7)
                  : const Color(0xFFC11336),
              borderRadius: BorderRadius.circular(24),
            ),
            child: _isSending
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: _isSending ? null : _sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            height: 220, // Yüksekliği artırdık
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFC11336),
                  Color(0xFFCD5970),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: _currentUser?.photoUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                _currentUser!.photoUrl,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 30,
                            ),
                    ),
                    const SizedBox(height: 16),

                    // User Name
                    Flexible(
                      child: Text(
                        _currentUser?.displayName ?? 'Kullanıcı',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Travel Personality
                    Flexible(
                      child: Text(
                        _currentUser?.seekerProfile.title ??
                            'Seyahat Kişiliğini Belirle',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Geçmiş Sohbetler Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Geçmiş Sohbetler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _chatHistory.length,
                    itemBuilder: (context, index) {
                      final chat = _chatHistory[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFC11336).withOpacity(0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFC11336).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline,
                                color: Color(0xFFC11336),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chat['title']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2C2C2C),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    chat['time']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Spacer to push content to top
          const Spacer(),
        ],
      ),
    );
  }
}
