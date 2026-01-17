import 'package:flutter/material.dart';
import 'package:saved/core/routing/app_router.dart';
import 'package:saved/features/chat/repository/chat_repository.dart';
import '../models/conversation.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  final ChatRepository _repository = ChatRepository();
  List<Conversation>? _conversations;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final conversations = await _repository.getConversations();
      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('خطأ: $_error'))
              : _conversations == null || _conversations!.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('لا توجد محادثات', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _conversations!.length,
                      itemBuilder: (context, index) {
                        final conversation = _conversations![index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: conversation.otherUserAvatar != null
                                ? NetworkImage(conversation.otherUserAvatar!)
                                : null,
                            child: conversation.otherUserAvatar == null
                                ? Text(conversation.otherUserName[0])
                                : null,
                          ),
                          title: Text(conversation.otherUserName),
                          subtitle: Text(
                            conversation.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: conversation.unreadCount > 0
                              ? CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    '${conversation.unreadCount}',
                                    style: const TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                )
                              : null,
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              AppRouter.chat,
                              arguments: {
                                'apartmentId': conversation.apartmentId,
                                'otherUserId': conversation.otherUserId,
                                'otherUserName': conversation.otherUserName,
                              },
                            );
                            await Future.delayed(const Duration(milliseconds: 500));
                            _loadConversations();
                          },
                        );
                      },
                    ),
    );
  }
}