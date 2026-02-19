import 'dart:convert';
import 'package:http/http.dart' as http;

/// OpenAI Chat Completion Service
/// Handles communication with OpenAI API for customer support chat responses
class OpenAIService {
  // WARNING: API key should NOT be hardcoded in production.
  // In production, store this securely using:
  // - Environment variables (with flutter_dotenv package)
  // - Secure storage (flutter_secure_storage)
  // - Backend proxy (recommended for security)
  // For now, using a placeholder - replace with your actual API key from environment
  static const String _apiKey = 'sk-YOUR_API_KEY_HERE';
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  // System instruction for customer support context
  static const String _systemInstruction =
      'You are a helpful customer support assistant for an online shopping app. '
      'Provide short and clear product summaries. Keep responses concise and friendly. '
      'Focus on helping with order issues, product questions, and shipping information.';

  /// Get AI-generated response from OpenAI
  /// 
  /// Args:
  ///   userMessage: The user's message/question
  /// 
  /// Returns:
  ///   A string containing the AI's response
  /// 
  /// Throws:
  ///   Exception if API call fails or returns error status
  Future<String> getChatResponse(String userMessage) async {
    try {
      // Prepare request body with GPT-4o-mini model and token limit
      final requestBody = {
        'model': 'gpt-4o-mini',
        'messages': [
          {
            'role': 'system',
            'content': _systemInstruction,
          },
          {
            'role': 'user',
            'content': userMessage,
          },
        ],
        'max_tokens': 150, // Limit response length for faster responses
        'temperature': 0.7, // Balanced between deterministic and creative
      };

      // Make HTTP POST request to OpenAI API
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        // 30-second timeout to prevent hanging requests
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('OpenAI API request timed out'),
      );

      // Handle API response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Extract AI response from API response structure
        final choices = data['choices'] as List<dynamic>;
        if (choices.isNotEmpty) {
          final firstChoice = choices[0] as Map<String, dynamic>;
          final message = firstChoice['message'] as Map<String, dynamic>;
          final content = message['content'] as String;
          return content.trim();
        }
        throw Exception('No response content from OpenAI API');
      } else if (response.statusCode == 401) {
        throw Exception('OpenAI API key is invalid or missing');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later');
      } else if (response.statusCode == 500) {
        throw Exception('OpenAI service is temporarily unavailable');
      } else {
        throw Exception(
          'OpenAI API error: ${response.statusCode} - ${response.body}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get AI response: ${e.toString()}');
    }
  }
}
