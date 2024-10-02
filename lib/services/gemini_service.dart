import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:health_tracker_flutter/api_key.dart';

class GeminiService {
  Future<String?> callGenerativeAI(String userInput) async {
    // Create the API client
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    // Create an enforced prompt
    String prompt =
        "As a personal trainer, provide a specific workout routine based on the following input: '$userInput'. "
        "Make sure the advice is practical and actionable without mentioning individual physical conditions or health concerns.";

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    if (response.text != null) {
      debugPrint(response.text);
      return _cleanResponse(response.text!);
    } else {
      return "Response is null";
    }
  }

  // Method to clean the response text
  String _cleanResponse(String response) {
    // Remove special characters used for bold formatting (like **)
    return response.replaceAll(RegExp(r'\*\*'), ''); // Removes the ** symbols
  }
}
