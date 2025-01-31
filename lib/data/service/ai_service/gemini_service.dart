import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ai_service.dart';

class GeminiService implements AiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Invalid or missing GEMINI_API_KEY in .env file');
    }

    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  @override
  Future<String> getResponse(String prompt, String userId) async {
    try {
      final content = [
        Content.text(
          'You are a friendly AI assistant that always responds in one concise line. '
          'If given a request for a joke, make it friendly and appropriate. '
          'If asked for motivation, be inspiring and try to give motivational words of great people. '
          'Current request: $prompt')
      ];

      final response = await _model.generateContent(content);
      final text = response.text;
      
      if (text == null || text.isEmpty) {
        throw Exception('Empty response from Gemini');
      }

      return text.trim().replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ');
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }
}
