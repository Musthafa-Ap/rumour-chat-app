import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/room.dart';
import '../models/message.dart';
import '../models/user.dart' as app_user;
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/date_separator.dart';
import 'join_room_screen.dart';

class ChatScreen extends StatefulWidget {
  final Room room;
  final app_user.User user;

  const ChatScreen({
    super.key,
    required this.room,
    required this.user,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().initializeChat(widget.room);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    // context.read<ChatProvider>().reset();
    super.dispose();
  }

  List<Widget> _buildMessageList(List<Message> messages) {
    final widgets = <Widget>[];
    DateTime? lastDate;

    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      // add date separator if date changed
      if (lastDate != messageDate) {
        widgets.add(DateSeparator(date: message.timestamp));
        lastDate = messageDate;
      }

      // check if next message is from a different user
      final showUserName = i == messages.length - 1 ||
          messages[i + 1].userId != message.userId;

      widgets.add(
        MessageBubble(
          message: message,
          isCurrentUser: message.userId == widget.user.id,
          showUserName: showUserName,
        ),
      );
    }

    // add load more button at the end
    if (messages.isNotEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                return chatProvider.isLoadingMore
                    ? const SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
                          strokeWidth: 2,
                        ),
                      )
                    : TextButton(
                        onPressed: () =>
                            chatProvider.loadMoreMessages(widget.room.id),
                        child: const Text(
                          'Load earlier messages',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const JoinRoomScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text('Room #${widget.room.code}'),
              Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  return Text(
                    '${chatProvider.memberCount} members',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            icon: SvgPicture.asset('assets/images/back_button.svg'),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const JoinRoomScreen()),
              );
            },
          ),
          elevation: 1,
        ),
        body: Consumer<ChatProvider>(
          builder: (context, chatProvider, _) {
            return Column(
              children: [
              
                Expanded(
                  child: chatProvider.messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 48,
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No messages yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start the conversation!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                  color: AppColors.textSecondary
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          controller: _scrollController,
                          reverse: true,
                          children: _buildMessageList(chatProvider.messages),
                        ),
                ),

           
                SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      color:Colors.transparent,
                    
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                             
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                             
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              filled: true,
                              fillColor: AppColors.tertiary,
                            ),
                            maxLines: null,
                            enabled: !chatProvider.isSending,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: IconButton(
                            icon:SvgPicture.asset('assets/images/send.svg'),
                            onPressed: chatProvider.isSending
                                ? null
                                : () {
                                    final text = _messageController.text;
                                    if (text.trim().isNotEmpty) {
                                      chatProvider.sendMessage(
                                        widget.room.id,
                                        widget.user.id,
                                        widget.user.displayName,
                                        text,
                                      );
                                      _messageController.clear();
                                    }
                                  },
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
