import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/app_state.dart';
import '../../services/huggingface_service.dart';
import '../../models/message_model.dart';
import 'dart:math';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final HuggingFaceService _hfService = HuggingFaceService();

  /// Send user message and get AI response via Hugging Face API
  /// Prevents multiple concurrent API calls and provides loading indicator
  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final appState = Provider.of<AppState>(context, listen: false);
    final user = appState.user;
    
    if (user == null) return;
    
    // Prevent multiple concurrent API calls
    if (appState.isLoadingChat) return;

    // Add user message immediately to UI
    final userMessage = MessageModel(
      messageId: _generateMessageId(),
      userId: user.userId,
      messageText: text,
      sender: 'user',
      timestamp: DateTime.now(),
    );
    appState.addMessage(userMessage);
    _controller.clear();

    // Set loading state to prevent duplicate requests
    appState.setLoadingChat(true);

    try {
      // Call Hugging Face API to get AI response
      final aiResponse = await _hfService.generateResponse(text);

      // Only proceed if widget is still mounted
      if (!mounted) return;

      // Create and add AI message to chat
      final aiMessage = MessageModel(
        messageId: _generateMessageId(),
        userId: user.userId,
        messageText: aiResponse,
        sender: 'assistant',
        timestamp: DateTime.now(),
      );
      appState.addMessage(aiMessage);
    } catch (e) {
      // Show error message to user
      if (!mounted) return;
      
      final errorMessage = MessageModel(
        messageId: _generateMessageId(),
        userId: user.userId,
        messageText: 'Sorry, I couldn\'t process your request. Error: ${e.toString()}',
        sender: 'assistant',
        timestamp: DateTime.now(),
      );
      appState.addMessage(errorMessage);

      // Also show error snackbar for better UX
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chat error: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      // Always clear loading state
      if (mounted) {
        appState.setLoadingChat(false);
      }
    }
  }

  /// Generate unique message ID
  String _generateMessageId() {
    return 'msg_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  String _formatTime(DateTime t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final messages = appState.messages;

    return Scaffold(
      backgroundColor: const Color(0xFF081017),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppBar(
          backgroundColor: const Color(0xFF071018),
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/home')),
          title: Row(children: [
            CircleAvatar(radius: 18, child: Text(appState.user?.name.substring(0, 1) ?? '?')),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              const Text('AI Assistant', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Online now', style: TextStyle(color: Colors.green[400], fontSize: 12)),
            ])
          ]),
          actions: [IconButton(icon: const Icon(Icons.info_outline), onPressed: () {})],
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final m = messages[index];
              final isUser = m.sender == 'user';

              // If message seems like an order-status reply, show an order card after it
              final showOrderCard = (m.intent == 'order_status' || m.messageText.toLowerCase().contains('order'));

              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : const Color(0xFF0F1720),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: Radius.circular(isUser ? 14 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 14),
                      ),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(m.messageText, style: TextStyle(color: isUser ? Colors.white : Colors.white70)),
                      const SizedBox(height: 6),
                      Align(alignment: Alignment.bottomRight, child: Text(_formatTime(m.timestamp), style: TextStyle(color: Colors.white54, fontSize: 11)))
                    ]),
                  ),
                ),

                if (showOrderCard && !isUser)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _OrderCard(),
                  )
              ]);
            },
          ),
        ),

        // Loading indicator while AI is processing
        if (Provider.of<AppState>(context).isLoadingChat)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1720),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
                      ),
                      const SizedBox(width: 8),
                      Text('AI is thinking...', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // Input area
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          color: const Color(0xFF071018),
          child: Row(children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline, color: Colors.white70)),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: const Color(0xFF0E1A21), borderRadius: BorderRadius.circular(30)),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !Provider.of<AppState>(context).isLoadingChat,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(hintText: 'Message...', border: InputBorder.none, hintStyle: TextStyle(color: Colors.white38)),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined, color: Colors.white70))
                ]),
              ),
            ),
            const SizedBox(width: 8),
            // Send button with loading indicator
            Provider.of<AppState>(context).isLoadingChat
                ? const SizedBox(
                    width: 40,
                    height: 40,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
                    ),
                  )
                : FloatingActionButton(onPressed: _send, mini: true, backgroundColor: Colors.blueAccent, child: const Icon(Icons.send)),
          ]),
        )
      ]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: const Color(0xFF0B1320), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 6))]),
      child: Column(children: [
        // Map placeholder
        Container(
          height: 140,
          decoration: BoxDecoration(color: Colors.grey[800], borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: const Center(child: Icon(Icons.map, color: Colors.white24, size: 48)),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Order #12345', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), Text('85%', style: TextStyle(color: Colors.white70))]),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: 0.85, color: Colors.blueAccent, backgroundColor: Colors.white12, minHeight: 6)),
            const SizedBox(height: 12),
            Row(children: const [Icon(Icons.location_on, color: Colors.blueAccent, size: 16), SizedBox(width: 8), Text('In your neighborhood', style: TextStyle(color: Colors.white70))]),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Track Order')))),
          ]),
        )
      ]),
    );
  }
}
