class ChatMessage {
  final String date;
  final String sender;
  final String avatarUrl;
  final String message;
  final String time;
  final List<String> attachments;

  ChatMessage({
    required this.date,
    required this.sender,
    required this.avatarUrl,
    required this.message,
    required this.time,
    required this.attachments,
  });
}
