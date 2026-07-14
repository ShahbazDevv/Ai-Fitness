import 'package:get/get.dart';
import '../../models/chat_model.dart';
import '../huggingface_service.dart';
import 'prompt_builder.dart';
import 'conversation_manager.dart';

class AiCoachService extends GetxService {
  final HuggingFaceService _hf = Get.find<HuggingFaceService>();
  final PromptBuilder _promptBuilder = PromptBuilder();
  final ConversationManager _conversationManager = Get.find<ConversationManager>();

  Future<String> getPersonalizedResponse(String userMessage, List<ChatMessage> history) async {
    final systemPrompt = _promptBuilder.buildSystemPrompt();
    final messages = _buildMessages(history, systemPrompt);

    String response;
    try {
      response = await _hf.chatCompletion(userMessage, messages);
    } catch (e) {
      try {
        response = await _hf.chatCompletion(userMessage, messages);
      } catch (e2) {
        response = "I'm having trouble connecting right now. Please check your internet and try again. In the meantime, focus on staying hydrated and maintaining good form!";
      }
    }

    return _injectMotivation(response, userMessage);
  }

  Future<String> generateWorkout({
    required String userRequest,
    required String availableTime,
    required String location,
    required String equipment,
  }) async {
    final workoutPrompt = _promptBuilder.buildWorkoutPrompt(userRequest, availableTime, location, equipment);
    try {
      return await _hf.chatCompletion(workoutPrompt, []);
    } catch (e) {
      try {
        return await _hf.chatCompletion(workoutPrompt, []);
      } catch (e2) {
        return "I couldn't generate a workout right now. Here's a quick suggestion: 3 sets of bodyweight squats (15 reps), 3 sets of push-ups (10 reps), 3 sets of lunges (12 each leg). Rest 60s between sets.";
      }
    }
  }

  List<Map<String, String>> _buildMessages(List<ChatMessage> history, String systemPrompt) {
    final messages = <Map<String, String>>[];
    messages.add({'role': 'system', 'content': systemPrompt});
    final recentHistory = history.length > 20 ? history.sublist(history.length - 20) : history;
    for (final msg in recentHistory) {
      messages.add({
        'role': msg.isUser ? 'user' : 'assistant',
        'content': msg.text,
      });
    }
    return messages;
  }

  String _injectMotivation(String response, String userMessage) {
    final lowerMsg = userMessage.toLowerCase();
    if (lowerMsg.contains('workout') || lowerMsg.contains('exercise') || lowerMsg.contains('train')) {
      return '$response\n\n💪 ${_conversationManager.getMotivation()}';
    }
    if (lowerMsg.contains('protein') || lowerMsg.contains('diet') || lowerMsg.contains('eat') || lowerMsg.contains('nutrition')) {
      return '$response\n\n🥗 ${_conversationManager.getMotivation()}';
    }
    return response;
  }

  String checkSafety(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('chest pain') || lower.contains('heart') || lower.contains('dizziness') ||
        lower.contains('severe pain') || lower.contains('serious injury') || lower.contains('broken')) {
      return "⚠️ I'm not a medical professional. Based on what you've described, I strongly recommend consulting a qualified healthcare provider immediately. Your health and safety come first.";
    }
    return '';
  }

  String getDailyCheckInPrompt() {
    return "How did you sleep last night? (hours) | Energy level (1-10) | Mood (1-10) | Muscle soreness (1-10) | Any pain or injury concerns?";
  }

  void processCheckInResponse(String response) {
    final parts = response.split('|');
    if (parts.length >= 1) {
      final sleep = int.tryParse(parts[0].trim().replaceAll(RegExp(r'[^0-9]'), ''));
      if (sleep != null) _conversationManager.sleepHours.value = sleep;
    }
    if (parts.length >= 2) {
      final energy = int.tryParse(parts[1].trim().replaceAll(RegExp(r'[^0-9]'), ''));
      if (energy != null) _conversationManager.energyLevel.value = energy;
    }
    if (parts.length >= 3) {
      final mood = int.tryParse(parts[2].trim().replaceAll(RegExp(r'[^0-9]'), ''));
      if (mood != null) _conversationManager.moodLevel.value = mood;
    }
    if (parts.length >= 4) {
      final soreness = int.tryParse(parts[3].trim().replaceAll(RegExp(r'[^0-9]'), ''));
      if (soreness != null) _conversationManager.sorenessLevel.value = soreness;
    }
    if (parts.length >= 5) {
      _conversationManager.painNotes.value = parts[4].trim();
    }
    _conversationManager.hasCheckedInToday.value = true;
  }
}
