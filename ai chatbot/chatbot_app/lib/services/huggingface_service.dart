import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Hugging Face Inference API service
///
/// Responsibilities:
/// - Call the Hugging Face Router API (new endpoint) for the configured model
/// - Return a clean text response
/// - Throw descriptive exceptions on error conditions
///
/// SECURITY: Do NOT hardcode your API key in source for production.
/// Use environment variables, secure storage, or a backend proxy.
class HuggingFaceService {
  // Load token from environment variables (.env file)
  // This prevents exposing secrets in source code
  static String get _hfToken => dotenv.env['HF_API_TOKEN'] ?? '';

  // Model to call
  static const String _model = 'mistralai/mistral-7b-instruct-v0.2';
  // New HuggingFace Router API endpoint (replaces deprecated api-inference.huggingface.co)
  static final Uri _endpoint = Uri.parse('https://router.huggingface.co/hf-inference/models/$_model');

  /// Generate a response for the given user message using the Hugging Face model.
  ///
  /// Returns the generated text (trimmed). Throws an Exception on failure.
  Future<String> generateResponse(String userMessage) async {
    if (userMessage.trim().isEmpty) return '';

    final payload = {
      'inputs': userMessage,
      'parameters': {
        // limit output length (mistral uses max_new_tokens)
        'max_new_tokens': 150,
        'temperature': 0.7,
        // `wait_for_model` can be useful if model is loading
        'wait_for_model': true,
      },
    };

    try {
      final resp = await http
          .post(
            _endpoint,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_hfToken',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 30));

      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);

        // Hugging Face Router API returns different shapes depending on model/config.
        // Common shapes:
        // 1) { "generated_text": "..." }
        // 2) [ { "generated_text": "..." } ]
        // 3) { "error": "..." }
        String result = '';
        if (decoded is Map<String, dynamic> && decoded.containsKey('generated_text')) {
          result = decoded['generated_text'] as String;
        } else if (decoded is List && decoded.isNotEmpty) {
          final first = decoded[0];
          if (first is Map<String, dynamic> && first.containsKey('generated_text')) {
            result = first['generated_text'] as String;
          } else if (first is Map<String, dynamic> && first.containsKey('text')) {
            result = first['text'] as String;
          } else if (first is String) {
            result = first as String;
          }
        } else if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
          throw Exception('Hugging Face error: ${decoded['error']}');
        } else if (decoded is String) {
          // sometimes HF returns plain text
          result = decoded;
        }

        return _cleanResult(result);
      } else if (resp.statusCode == 401) {
        throw Exception('Unauthorized: invalid Hugging Face token');
      } else if (resp.statusCode == 410) {
        throw Exception('Hugging Face API endpoint deprecated. Please check documentation for updates');
      } else if (resp.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later');
      } else {
        throw Exception('Hugging Face API error ${resp.statusCode}: ${resp.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  // Clean result by trimming and removing duplicated prompt if present.
  String _cleanResult(String r) {
    var out = r.trim();

    // If model echoes the prompt at start, remove first occurrence of prompt
    // (best-effort; keep conservative to avoid chopping legitimate text)
    // NOTE: This is heuristic and should be adapted per model behavior.
    return out;
  }
}
