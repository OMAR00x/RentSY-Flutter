import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saved/constants/app_colors.dart';
import '../cubit/chat_cubit.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final int apartmentId;
  final int otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.apartmentId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadMessages(widget.apartmentId);
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == 'new_message' && 
          message.data['apartment_id'] == widget.apartmentId.toString()) {
        context.read<ChatCubit>().loadMessages(widget.apartmentId);
      }
    });
  }

  @override
  void dispose() {
    context.read<ChatCubit>().markMessagesAsRead(widget.apartmentId);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oat.withValues(alpha: 0.3),
      appBar: AppBar(
        title: Text(widget.otherUserName, style: GoogleFonts.lato(color: AppColors.charcoal, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.oat,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.charcoal),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.charcoal));
                }
                if (state is ChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: AppColors.taupe),
                        const SizedBox(height: 16),
                        Text('خطأ: ${state.message}', style: GoogleFonts.lato(color: AppColors.mocha)),
                      ],
                    ),
                  );
                }
                if (state is ChatLoaded) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.taupe),
                          const SizedBox(height: 16),
                          Text('ابدأ المحادثة', style: GoogleFonts.lato(color: AppColors.taupe, fontSize: 16)),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[state.messages.length - 1 - index];
                      final isMe = message.fromUserId != widget.otherUserId;
                      return _MessageBubble(message: message, isMe: isMe);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.taupe.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.oat.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.lato(color: AppColors.charcoal),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة...',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: GoogleFonts.lato(color: AppColors.taupe),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.charcoal,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    context.read<ChatCubit>().sendMessage(
          toUserId: widget.otherUserId,
          apartmentId: widget.apartmentId,
          body: _controller.text.trim(),
        );
    _controller.clear();
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.charcoal : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.taupe.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.body,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.lato(
                    color: isMe ? Colors.white : AppColors.charcoal,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.createdAt),
                  style: GoogleFonts.lato(
                    color: isMe ? Colors.white70 : AppColors.taupe,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
