class ChatMessage {
  final String text;
  final bool isUser;
  final String time;
  final List<String> relatedTerms; // 관련 용어 리스트 추가

  ChatMessage({
    required this.text,
    required this.isUser,
    this.relatedTerms = const [], // 기본값은 빈 리스트
  }) : time =
           '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
}
