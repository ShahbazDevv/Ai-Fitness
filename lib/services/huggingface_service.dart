import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/environment.dart';

class HuggingFaceService extends GetxService {
  final String _apiKey = Environment.hfApiKey;
  final String _model = Environment.hfModel;
  final String _baseUrl = Environment.hfBaseUrl;
  bool _isOffline = true;

  Future<HuggingFaceService> init() async {
    if (_apiKey.isEmpty || _apiKey.contains('placeholder')) {
      print('HF_API_KEY is empty. Running HuggingFace in offline mock mode.');
      _isOffline = true;
    } else {
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/chat/completions'),
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': _model,
            'messages': [
              {'role': 'user', 'content': 'respond with just the word ok'}
            ],
            'max_tokens': 10,
          }),
        ).timeout(const Duration(seconds: 10));
        _isOffline = response.statusCode != 200;
        print('HuggingFace model initialized. Online: ${!_isOffline}');
      } catch (e) {
        print('HuggingFace initialization failed: $e. Running in offline mock mode.');
        _isOffline = true;
      }
    }
    return this;
  }

  bool get isOffline => _isOffline;

  Future<String> chatCompletion(
    String message,
    List<Map<String, String>> history,
  ) async {
    if (_isOffline) {
      await Future.delayed(const Duration(seconds: 1));
      return _mockChatResponse(message);
    }

    final messages = [
      ...history,
      {'role': 'user', 'content': message},
    ];

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 800,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      }
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    } catch (e) {
      print('HuggingFaceService: chatCompletion error: $e');
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/chat/completions'),
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': _model,
            'messages': messages,
            'temperature': 0.7,
            'max_tokens': 800,
          }),
        ).timeout(const Duration(seconds: 30));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['choices'][0]['message']['content'] as String;
        }
      } catch (e2) {
        print('HuggingFaceService: chatCompletion retry failed: $e2');
      }
      return _mockChatResponse(message);
    }
  }

  Future<Map<String, dynamic>> analyzeBodyScan(
      Uint8List frontImage, Uint8List sideImage, Uint8List backImage) async {
    if (_isOffline) {
      await Future.delayed(const Duration(seconds: 2));
      return _mockBodyScanResult();
    }

    try {
      final frontBase64 = base64Encode(frontImage);
      final sideBase64 = base64Encode(sideImage);
      final backBase64 = base64Encode(backImage);

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': 'Analyze these three body photos (Front, Side, Back) for fitness coaching. '
                      'Provide a JSON output containing: bodyFat (estimate), muscleMass, posture, '
                      'fitnessLevel, strength, weakness, workoutPlan, dietPlan, advice. '
                      'Return ONLY valid JSON.'
                },
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$frontBase64'},
                },
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$sideBase64'},
                },
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$backBase64'},
                },
              ],
            },
          ],
          'max_tokens': 1000,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['message']['content'] as String;
        final cleanText = text
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        return jsonDecode(cleanText) as Map<String, dynamic>;
      }
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    } catch (e) {
      print('HuggingFaceService: analyzeBodyScan error: $e');
      return _mockBodyScanResult();
    }
  }

  Future<String> generateWorkoutRecommendation(String goal, String level, String equipment) async {
    if (_isOffline) {
      await Future.delayed(const Duration(milliseconds: 1500));
      return _mockWorkoutPlan();
    }
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'user',
              'content':
                  "Generate a structured fitness workout plan in markdown for a $level athlete looking to achieve $goal using $equipment. Include exercises, sets, reps, and rest times.",
            },
          ],
          'max_tokens': 800,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      }
      throw Exception('HTTP ${response.statusCode}');
    } catch (e) {
      print('HuggingFaceService: generateWorkoutRecommendation error: $e');
      return _mockWorkoutPlan();
    }
  }

  Future<Map<String, dynamic>> generateDietRecommendation(
      double weight, double height, String goal, String allergy) async {
    if (_isOffline) {
      await Future.delayed(const Duration(milliseconds: 1500));
      return _mockDietResult();
    }
    try {
      final prompt =
          "Generate a daily diet recommendation for a person with weight $weight kg, height $height cm, goal: $goal, allergies/restrictions: $allergy. "
          "Return a JSON with keys: calories (int), protein (int grams), carbs (int grams), fats (int grams), breakfast (string), lunch (string), dinner (string), snack (string).";

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 600,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['message']['content'] as String;
        final cleanText = text.replaceAll('```json', '').replaceAll('```', '').trim();
        return jsonDecode(cleanText) as Map<String, dynamic>;
      }
      throw Exception('HTTP ${response.statusCode}');
    } catch (e) {
      print('HuggingFaceService: generateDietRecommendation error: $e');
      return _mockDietResult();
    }
  }

  String _mockChatResponse(String message) {
    if (message.toLowerCase().contains('hiit') || message.toLowerCase().contains('cardio')) {
      return "Based on your current fat percentage and recovery logs, I suggest a 20-minute active recovery session today. Switch to a Zone 2 jog or light swimming to promote blood flow and muscle repair.";
    }
    return "That sounds like a solid plan. To maximize hypertrophy, keep your sets in the 8-12 rep range with 90 seconds of rest. Remember to hit at least 150g of protein today to assist muscle recovery!";
  }

  Map<String, dynamic> _mockBodyScanResult() {
    return {
      'bodyFat': '14.5%',
      'muscleMass': 'High',
      'posture': 'Good (Slight anterior pelvic tilt)',
      'fitnessLevel': 'Intermediate',
      'strength': 'Strong shoulders and upper back muscles.',
      'weakness': 'Tight hamstrings and lower back fatigue.',
      'workoutPlan': 'Add core stability work, plank variations, and hamstring stretches.',
      'dietPlan': 'Increase clean carb intake to 250g and maintain protein at 160g.',
      'advice': 'Perform foam rolling on your quads and take dynamic stretches before workouts.',
    };
  }

  String _mockWorkoutPlan() {
    return "### AI Recommended Session: Hypertrophy Split\n"
        "1. Barbell Squats: 4 sets x 8 reps (Rest 2 mins)\n"
        "2. Romanian Deadlifts: 3 sets x 10 reps (Rest 90 secs)\n"
        "3. Leg Press: 3 sets x 12 reps\n"
        "4. Standing Calf Raises: 4 sets x 15 reps\n"
        "**Focus**: Control the eccentric phase for 3 seconds on squats.";
  }

  Map<String, dynamic> _mockDietResult() {
    return {
      'calories': 2400,
      'protein': 180,
      'carbs': 250,
      'fats': 70,
      'breakfast': 'Protein Oat Bowl (Steel-cut oats, whey, mixed berries)',
      'lunch': 'Grilled Chicken & Rice (Chicken breast, basmati rice, broccoli)',
      'dinner': 'Seared Salmon & Avocado (Wild salmon, sweet potatoes, asparagus)',
      'snack': 'Greek Yogurt & Almonds',
    };
  }
}
