import 'package:kisan_app/src/data_layer/repository/messageRepository.dart';

class MessageController {
  MessageRepository _repository = MessageRepository();

  // For creating a chat room between AgriExpert and Farmer
  Future<String> createChatRoom({
    String agriExpertUid,
    String farmerUid,
  }) async {
    return await _repository.createChatRoom(
      agriExpertUid: agriExpertUid,
      farmerUid: farmerUid,
    );
  }

  // For getting past messages
  Stream getConversationMessages(String chatRoomId) {
    return _repository.getConversationMessages(chatRoomId);
  }

  // Adding messages
  addConversationMessages(String chatRoomId, messageMap) {
    _repository.addConversationMessages(chatRoomId, messageMap);
  }

  // Getting chat rooms
  Stream getChatRooms(String userName) {
    return _repository.getChatRooms(userName);
  }

  // Deleting chats document
  Future<void> deleteChatRoomDocument(String chatRoomId) async {
    await _repository.deleteChatRoomDocument(chatRoomId);
  }
}
