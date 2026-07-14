import 'dart:io';
import 'package:get/get.dart';
import '../models/chat_model.dart';
import '../services/supabase_service.dart';
import '../services/huggingface_service.dart';
import '../services/storage_service.dart';
import '../services/ai/ai_coach_service.dart';
import 'package:uuid/uuid.dart';

class AiRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();
  final HuggingFaceService _hf = Get.find<HuggingFaceService>();
  final StorageService _storage = Get.find<StorageService>();
  final _uuid = const Uuid();

  // Chat queries
  Future<List<ChatMessage>> getChatHistory() async {
    if (_supabase.isMockMode) {
      return [
        ChatMessage(
          id: '1',
          text: "Good morning! I analyzed your recovery metrics from yesterday's heavy lifting session. Your CNS seems a bit fatigued. I recommend switching today's planned HIIT to a Zone 2 active recovery. How does that sound?",
          isUser: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        ChatMessage(
          id: '2',
          text: "Yeah, my legs are definitely feeling it. What kind of Zone 2 work should I do?",
          isUser: true,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ];
    }
    try {
      final response = await _supabase.client
          .from('chat_history')
          .select()
          .order('timestamp', ascending: true);
      return (response as List).map((x) => ChatMessage.fromJson(x)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatMessage> sendMessage(String text, List<ChatMessage> previousMessages) async {
    final userMsgId = _uuid.v4();
    final userMessage = ChatMessage(
      id: userMsgId,
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Save user message to database
    if (!_supabase.isMockMode) {
      try {
        final userId = _supabase.currentUser.value?.id;
        await _supabase.client.from('chat_history').insert({
          'id': userMsgId,
          'user_id': userId,
          'text': text,
          'is_user': true,
          'timestamp': userMessage.timestamp.toIso8601String(),
        });
      } catch (e) {
        print('Failed to save user chat: $e');
      }
    }

    // Use the new AI Coach Service for personalized responses
    final aiCoachService = Get.find<AiCoachService>();
    final responseText = await aiCoachService.getPersonalizedResponse(text, previousMessages);

    final aiMsgId = _uuid.v4();
    final aiMessage = ChatMessage(
      id: aiMsgId,
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
    );

    // Save AI response to database
    if (!_supabase.isMockMode) {
      try {
        final userId = _supabase.currentUser.value?.id;
        await _supabase.client.from('chat_history').insert({
          'id': aiMsgId,
          'user_id': userId,
          'text': responseText,
          'is_user': false,
          'timestamp': aiMessage.timestamp.toIso8601String(),
        });
      } catch (e) {
        print('Failed to save AI chat: $e');
      }
    }

    return aiMessage;
  }

  // Vision Body Scan
  Future<Map<String, dynamic>> submitBodyScan({
    required File front,
    required File side,
    required File back,
  }) async {
    final userId = _supabase.currentUser.value?.id ?? 'user_1';
    final scanId = _uuid.v4();

    // Upload files to Supabase Storage
    String frontUrl = '';
    String sideUrl = '';
    String backUrl = '';

    try {
      frontUrl = await _storage.uploadBodyScanImage(front, userId, scanId, 'front');
      sideUrl = await _storage.uploadBodyScanImage(side, userId, scanId, 'side');
      backUrl = await _storage.uploadBodyScanImage(back, userId, scanId, 'back');
    } catch (e) {
      print('Failed storage upload, proceeding offline: $e');
    }

    // Convert files to bytes for Gemini Vision API
    final frontBytes = await front.readAsBytes();
    final sideBytes = await side.readAsBytes();
    final backBytes = await back.readAsBytes();

    final result = await _hf.analyzeBodyScan(frontBytes, sideBytes, backBytes);

    // Save Scan record to Database
    if (!_supabase.isMockMode) {
      try {
        await _supabase.client.from('body_scans').insert({
          'id': scanId,
          'user_id': userId,
          'front_image_url': frontUrl,
          'side_image_url': sideUrl,
          'back_image_url': backUrl,
          'body_fat': result['bodyFat'],
          'muscle_mass': result['muscleMass'],
          'posture': result['posture'],
          'fitness_level': result['fitnessLevel'],
          'strengths': result['strength'],
          'weaknesses': result['weakness'],
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        print('Failed to save body scan result: $e');
      }
    }

    return result;
  }

  // Clear Chat History
  Future<void> clearChatHistory() async {
    if (_supabase.isMockMode) return;
    try {
      final userId = _supabase.currentUser.value?.id;
      if (userId == null) return;
      await _supabase.client.from('chat_history').delete().eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }
}
