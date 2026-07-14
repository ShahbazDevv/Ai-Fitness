import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'glass_card.dart';
import 'package:intl/intl.dart';

class AiChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const AiChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final timeStr = DateFormat('hh:mm a').format(timestamp);

    Widget messageContent;
    if (isUser) {
      messageContent = Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: AppColors.redGradient,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: AppTextStyles.bodyLg.copyWith(color: Colors.white),
        ),
      );
    } else {
      messageContent = GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 16,
        child: Text(
          text,
          style: AppTextStyles.bodyLg.copyWith(color: AppColors.textPrimary),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Align(
        alignment: alignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              messageContent,
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 10,
                    color: AppColors.textMuted.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    timeStr,
                    style: AppTextStyles.labelCaps.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textMuted.withValues(alpha: 0.5),
                    ),
                  ),
                  if (isUser) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.done_all,
                      size: 12,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
