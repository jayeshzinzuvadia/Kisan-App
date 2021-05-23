import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class MessageService {
  // Collection Reference for AppUser Collection
  final CollectionReference _chatRoomCollection =
      FirebaseFirestore.instance.collection(DbConstant.CHATROOM_COLLECTION);

  // Generate unique room id
  String getChatRoomId(String a, String b) {
    // if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    //   return "$b\_$a"; // + getRandomDocumentId();
    // } else {
    //   return "$a\_$b"; //+ getRandomDocumentId();
    // }
    return "$a\_$b";
  }

  // Code taken from stackoverflow
  String getRandomDocumentId() {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
    Random _rnd = Random();
    int length = 15;
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  // Creating chat room
  Future<String> createChatRoom(
      {String agriExpertUid, String farmerUid}) async {
    String chatRoomId = getChatRoomId(agriExpertUid, farmerUid);
    print("Chat room id is " + chatRoomId);

    List<String> members = [agriExpertUid, farmerUid];

    Map<String, dynamic> chatRoomMap = {
      "Members": members,
      "ChatRoomId": chatRoomId,
    };
    await _chatRoomCollection
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) => print(e.toString()));
    return chatRoomId;
  }

  addConversationMessages(String chatRoomId, messageMap) async {
    await _chatRoomCollection
        .doc(chatRoomId)
        .collection(DbConstant.CHAT_COLLECTION)
        .add(messageMap)
        .catchError((e) => print(e.toString()));
  }

  Stream getConversationMessages(String chatRoomId) {
    return _chatRoomCollection
        .doc(chatRoomId)
        .collection(DbConstant.CHAT_COLLECTION)
        .orderBy("Time", descending: false)
        .snapshots();
  }

  // For agri expert user only
  Stream getChatRooms(String uid) {
    return _chatRoomCollection.where("Members", arrayContains: uid).snapshots();
  }

  // For agri expert only
  Future<void> deleteChatRoomDocument(String chatRoomId) async {
    return await _chatRoomCollection.doc(chatRoomId).delete();
  }
}
