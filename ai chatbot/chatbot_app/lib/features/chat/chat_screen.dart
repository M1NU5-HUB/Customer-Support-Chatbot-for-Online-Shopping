import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../services/chat_service.dart';
import '../../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final user = Provider.of<AppState>(context, listen: false).user;
    if (user == null) return;
    final msg = await _chatService.sendMessage(user.userId, text);
    Provider.of<AppState>(context, listen: false).addMessage(msg);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<AppState>(context).messages;
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final m = messages[index];
                return ListTile(
                  title: Text(m.messageText),
                  subtitle: Text('${m.sender} • ${m.timestamp.toLocal()}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(onPressed: _send, icon: const Icon(Icons.send)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
