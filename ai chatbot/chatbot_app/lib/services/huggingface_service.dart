import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

/// Hugging Face Inference API service
///
/// Responsibilities:
/// - Call the Hugging Face Inference API for free model (distilgpt2)
/// - Return clean text response
/// - Throw descriptive exceptions on error conditions
///
/// SECURITY: Do NOT hardcode your API key in source for production.
/// Use environment variables, secure storage, or a backend proxy.
class HuggingFaceService {
  /// Static token for web/testing purposes
  /// On mobile/desktop, this is ignored in favor of .env file
  static String? _staticToken;

  /// Set token programmatically (useful for web/testing)
  static void setApiToken(String token) {
    _staticToken = token;
  }

  // Load token from environment variables (.env file) or static override
  static String get _hfToken {
    // First check if token was set programmatically (for web testing)
    if (_staticToken != null && _staticToken!.isNotEmpty) {
      return _staticToken!;
    }

    // Then try to load from .env file (works on mobile/desktop)
    try {
      final env = dotenv.env;
      if (env == null || env.isEmpty) return '';
      return env['HF_API_TOKEN'] ?? '';
    } catch (e) {
      // dotenv not initialized or not available (e.g., web platform)
      return '';
    }
  }

  // Free model - no inference provider required
  static const String _model = 'distilgpt2';
  // Free endpoint - no router needed
  static final Uri _endpoint = Uri.parse('https://api-inference.huggingface.co/models/$_model');

  /// Generate a response for the given user message using the Hugging Face model.
  ///
  /// Returns the generated text (trimmed). Throws an Exception on failure.
  Future<String> generateResponse(String userMessage) async {
    if (userMessage.trim().isEmpty) return '';

    // Check if token is loaded
    final token = _hfToken.trim();
    if (token.isEmpty || token == 'hf-YOUR_API_TOKEN_HERE') {
      throw Exception(
        'Hugging Face API token not configured.\n\n'
        'For WEB TESTING:\n'
        'Open browser console and paste:\n'
        'window.hfToken = "hf_YOUR_TOKEN_HERE"\n\n'
        'For MOBILE/DESKTOP:\n'
        'Add HF_API_TOKEN to your .env file'
      );
    }

    final payload = {
      'inputs': userMessage,
    };

    try {
      final resp = await http
          .post(
            _endpoint,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 30));

      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);

        // Free distilgpt2 model returns:
        // [ { "generated_text": "..." } ]
        String result = '';
        if (decoded is List && decoded.isNotEmpty) {
          final first = decoded[0];
          if (first is Map<String, dynamic> && first.containsKey('generated_text')) {
            result = first['generated_text'] as String;
          } else if (first is String) {
            result = first;
          }
        } else if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('generated_text')) {
            result = decoded['generated_text'] as String;
          } else if (decoded.containsKey('error')) {
            throw Exception('Hugging Face error: ${decoded['error']}');
          }
        } else if (decoded is String) {
          result = decoded;
        }

        return _cleanResult(result);
      } else if (resp.statusCode == 401) {
        throw Exception('Unauthorized: invalid Hugging Face token');
      } else if (resp.statusCode == 403) {
        throw Exception('Forbidden: access denied to this model');
      } else if (resp.statusCode == 410) {
        throw Exception('Model endpoint no longer available');
      } else if (resp.statusCode == 500) {
        throw Exception('Hugging Face server error: please try again later');
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
    // Remove extra whitespace
    out = out.replaceAll(RegExp(r'\s+'), ' ');
    return out;
  }
}
