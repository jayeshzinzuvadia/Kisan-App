import 'package:kisan_app/src/data_layer/services/messageService.dart';

class MessageRepository {
  MessageService _messageService = MessageService();

  // For creating a chat room between AgriExpert and Farmer
  Future<String> createChatRoom({
    String agriExpertUid,
    String farmerUid,
  }) async =>
      await _messageService.createChatRoom(
        agriExpertUid: agriExpertUid,
        farmerUid: farmerUid,
      );

  // For getting past messages
  Stream getConversationMessages(String chatRoomId) =>
      _messageService.getConversationMessages(chatRoomId);

  // Adding messages
  addConversationMessages(String chatRoomId, messageMap) =>
      _messageService.addConversationMessages(chatRoomId, messageMap);

  // Getting chat rooms
  getChatRooms(String userName) => _messageService.getChatRooms(userName);

  // Deleting chats document
  Future<void> deleteChatRoomDocument(String chatRoomId) async =>
      await _messageService.deleteChatRoomDocument(chatRoomId);
}
