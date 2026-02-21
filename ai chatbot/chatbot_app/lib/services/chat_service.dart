import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  /// Base URL for the proxy backend. Update to your host if needed.
  static const String baseUrl = 'http://localhost:3000';
  static const Duration _timeout = Duration(seconds: 30);

  /// Sends [message] to backend `/chat` and returns bot reply.
  /// Returns a fallback string on network/server errors.
  static Future<String> sendMessage(String message, {String sender = 'mobile_user_1'}) async {
    final uri = Uri.parse('$baseUrl/chat');
    try {
      final resp = await http
          .post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message, 'sender': sender}),
      )
          .timeout(_timeout);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data is Map<String, dynamic> && data['reply'] != null) {
          return data['reply'] as String;
        }
        return 'No reply from server.';
      } else if (resp.statusCode == 401) {
        return 'Unauthorized. Please check server configuration.';
      } else if (resp.statusCode == 403) {
        return 'Forbidden. Access denied.';
      } else if (resp.statusCode == 410) {
        return 'Service no longer available.';
      } else {
        return 'Server error, please try again.';
      }
    } catch (_) {
      return 'Server error, please try again.';
    }
  }
}
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
