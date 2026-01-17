class Message {
  final int id;
  final int fromUserId;
  final int toUserId;
  final int apartmentId;
  final String body;
  final DateTime createdAt;
  final DateTime? readAt;
  final User? fromUser;
  final User? toUser;

  Message({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.apartmentId,
    required this.body,
    required this.createdAt,
    this.readAt,
    this.fromUser,
    this.toUser,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      fromUserId: json['from_user_id'],
      toUserId: json['to_user_id'],
      apartmentId: json['apartment_id'],
      body: json['body'],
      createdAt: DateTime.parse(json['created_at']).add(const Duration(hours: 2)),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']).add(const Duration(hours: 2)) : null,
      fromUser: json['from_user'] != null ? User.fromJson(json['from_user']) : null,
      toUser: json['to_user'] != null ? User.fromJson(json['to_user']) : null,
    );
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String? avatar;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.avatar,
  });

  String get name => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar']?['url'],
    );
  }
}