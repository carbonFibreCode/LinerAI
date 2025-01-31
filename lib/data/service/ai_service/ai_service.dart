abstract class AiService {
  /// [prompt] The user's input text
  /// Returns a Future\<String>\ containing the AI's response
  Future<String> getResponse(String prompt, String userId);
} 