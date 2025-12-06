import 'package:flutter/material.dart';
import '../models/message.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isCurrentUser;
  final bool showUserName;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.showUserName = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.tertiary,
                child: Text(
                  message.userName.isNotEmpty ? message.userName[0].toUpperCase() : 'A',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isCurrentUser ? AppColors.messageBubbleSelf : AppColors.messageBubbleOther,
                border: !isCurrentUser
                    ? Border.all(color: AppColors.messageBubbleOtherBorder, width: 0.5)
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (showUserName && !isCurrentUser)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.userName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isCurrentUser ? AppColors.secondary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isCurrentUser ? AppColors.secondary : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('HH:mm').format(message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: isCurrentUser 
                            ? AppColors.secondary.withValues(alpha: 0.7) 
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: SizedBox(width: 32), 
            ),
        ],
      ),
    );
  }
}
