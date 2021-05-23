import 'package:flutter/material.dart';
import 'package:kisan_app/src/app.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/controllers/messageController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen({this.chatRoomId});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  MessageController _messageController = MessageController();
  AppUserController _controller = AppUserController();

  TextEditingController messageTextEditingController =
      new TextEditingController();

  Stream chatMessageStream;

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return StreamBuilder<AppUser>(
      stream: _controller.appUserInfo(_appUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: myAppBar(
              context,
              snapshot.data.userType == UniversalConstant.FARMER
                  ? "Chat with Expert"
                  : "Chat with Farmer",
            ),
            body: buildConversationView(snapshot.data),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Container buildConversationView(appUser) {
    return Container(
      child: Stack(
        children: [
          chatMessageList(appUser),
          inputMessageBox(appUser),
        ],
      ),
    );
  }

  Widget inputMessageBox(appUser) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                cursorColor: Colors.green,
                controller: messageTextEditingController,
                decoration: InputDecoration(
                  hintText: "Type your message here",
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                child: Icon(
                  Icons.send,
                  color: Colors.green,
                  size: 28.0,
                ),
              ),
              onTap: () {
                sendMessage(appUser);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget chatMessageList(appUser) {
    return StreamBuilder(
      stream: _messageController.getConversationMessages(widget.chatRoomId),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index].data()["Message"],
                    isSendByMe: snapshot.data.docs[index].data()["SendBy"] ==
                        appUser.uid,
                  );
                },
              )
            : Container();
      },
    );
  }

  sendMessage(appUser) {
    if (messageTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "Message": messageTextEditingController.text,
        "SendBy": appUser.uid,
        "Time": DateTime.now().millisecondsSinceEpoch,
      };
      _messageController.addConversationMessages(widget.chatRoomId, messageMap);
      messageTextEditingController.text = "";
    }
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile({this.message, this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: isSendByMe ? 0 : 10,
        right: isSendByMe ? 10 : 0,
      ),
      margin: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: isSendByMe ? Colors.lightGreen[700] : Colors.cyan[800],
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
          textWidthBasis: TextWidthBasis.longestLine,
        ),
      ),
    );
  }
}
