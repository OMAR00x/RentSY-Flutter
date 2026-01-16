class Conversation {
  final int apartmentId;
  final String apartmentTitle;
  final String? apartmentImage;
  final int otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isMyMessage;
  final int unreadCount;

  Conversation({
    required this.apartmentId,
    required this.apartmentTitle,
    this.apartmentImage,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isMyMessage,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      apartmentId: json['apartment_id'],
      apartmentTitle: json['apartment']['title'],
      apartmentImage: json['apartment']['images']?.isNotEmpty == true 
          ? json['apartment']['images'][0]['url'] 
          : null,
      otherUserId: json['other_user']['id'],
      otherUserName: '${json['other_user']['first_name']} ${json['other_user']['last_name']}',
      otherUserAvatar: json['other_user']['avatar']?['url'],
      lastMessage: json['last_message']['body'],
      lastMessageTime: DateTime.parse(json['last_message']['created_at']),
      isMyMessage: json['last_message']['is_mine'],
      unreadCount: json['unread_count'],
    );
  }
}