import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/ai_repository.dart';
import '../models/chat_model.dart';
import '../services/ai/ai_coach_service.dart';
import '../services/ai/conversation_manager.dart';

class AiCoachController extends GetxController {
  final AiRepository _aiRepo = AiRepository();
  final AiCoachService _aiCoachService = Get.find<AiCoachService>();
  final ConversationManager _conversationManager = Get.find<ConversationManager>();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;
  final RxBool showCheckIn = false.obs;

  final TextEditingController messageController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadChatHistory();
  }

  Future<void> loadChatHistory() async {
    isLoading.value = true;
    try {
      final history = await _aiRepo.getChatHistory();
      messages.value = history;
      _scrollToBottom();

      if (_conversationManager.shouldAskCheckIn) {
        showCheckIn.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chat history');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage({bool isCheckIn = false}) async {
    final text = isCheckIn ? checkInController.text.trim() : messageController.text.trim();
    if (text.isEmpty) return;

    if (isCheckIn) {
      _aiCoachService.processCheckInResponse(text);
      showCheckIn.value = false;
      checkInController.clear();
    }

    if (!isCheckIn) messageController.clear();

    // Check safety first
    final safetyMsg = _aiCoachService.checkSafety(text);
    if (safetyMsg.isNotEmpty) {
      final safetyAlert = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: safetyMsg,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(safetyAlert);
      _scrollToBottom();
      return;
    }

    // Show check-in prompt as a suggestion banner instead of blocking
    if (!isCheckIn && _conversationManager.shouldAskCheckIn) {
      showCheckIn.value = true;
    }

    // Optimistic UI update
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMsg);
    _scrollToBottom();

    isTyping.value = true;
    try {
      final aiResponse = await _aiRepo.sendMessage(text, messages.toList());
      messages.add(aiResponse);
      _scrollToBottom();
    } catch (e) {
      // Fallback local response
      final fallbackMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "I'm having trouble connecting to my servers. Please check your internet connection and try again.",
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(fallbackMessage);
      _scrollToBottom();
    } finally {
      isTyping.value = false;
    }
  }

  void runCheckIn() {
    if (!_conversationManager.hasCheckedInToday.value) {
      final checkInPrompt = _aiCoachService.getDailyCheckInPrompt();
      final checkInMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "Let's do a quick check-in: " + checkInPrompt,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(checkInMsg);
      messageController.text = "7 | 6 | 5 | 3 | None";
      showCheckIn.value = true;
      _scrollToBottom();
    }
  }

  void generateWorkout() {
    final WorkoutGenerationRequest request = WorkoutGenerationRequest(
      userRequest: "Generate a workout for me",
      availableTime: "60 minutes",
      location: "home",
      equipment: "dumbbells",
    );

    _aiCoachService.generateWorkout(
      userRequest: request.userRequest,
      availableTime: request.availableTime,
      location: request.location,
      equipment: request.equipment,
    ).then((result) {
      final wMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: result,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(wMsg);
      _scrollToBottom();
    });
  }

  void onInteractionEnded() {
    if (_conversationManager.hasCheckedInToday.value) {
      _conversationManager.resetCheckIn();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> clearChat() async {
    try {
      await _aiRepo.clearChatHistory();
      messages.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear chat');
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    checkInController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

class WorkoutGenerationRequest {
  final String userRequest;
  final String availableTime;
  final String location;
  final String equipment;

  WorkoutGenerationRequest({
    required this.userRequest,
    required this.availableTime,
    this.location = 'home',
    this.equipment = 'bodyweight',
  });
}
