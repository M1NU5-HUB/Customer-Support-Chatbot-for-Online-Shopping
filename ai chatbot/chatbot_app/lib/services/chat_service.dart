import '../models/message_model.dart';
import 'api_service.dart';

class ChatService {
  final ApiService _api = ApiService();

  Future<MessageModel> sendMessage(String userId, String text) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    return MessageModel(
      messageId: 'msg_${now.millisecondsSinceEpoch}',
      userId: userId,
      messageText: text,
      sender: 'user',
      timestamp: now,
    );
  }
}
