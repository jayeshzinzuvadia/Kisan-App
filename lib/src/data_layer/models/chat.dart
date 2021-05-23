class Chat {
  String message;
  String sender;
  int time;

  Chat({
    this.message,
    this.sender,
    this.time,
  });
}

class ChatRoom {
  Chat chat;
  Map users;
}
