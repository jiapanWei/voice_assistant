import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:voice_assistant/api_key.dart';

class APIService {
  Future<http.Response> requestOpenAI(
      String userInput, String mode, int maximumTokens) async {
    const String url = "https://api.openai.com/";
    final String openAIAPIUrl =
        mode == "chat" ? "v1/chat/completions" : "v1/images/generations";

    final body = mode == "chat"
        ? {
            "model": "gpt-3.5-turbo",
            "messages": [
              Map.of({"role": "user", "content": userInput})
            ],
          }
        : {
            "prompt": userInput,
          };

    final responseFromOpenAIAPI = await http.post(
      Uri.parse(url + openAIAPIUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey"
      },
      body: jsonEncode(body),
    );

    return responseFromOpenAIAPI;
  }
}
