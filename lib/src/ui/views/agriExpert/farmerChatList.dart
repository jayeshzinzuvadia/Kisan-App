import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/controllers/messageController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/views/shared/conversation.dart';
import 'package:kisan_app/src/ui/widgets/alertDialogBox.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/mySnackBar.dart';
import 'package:provider/provider.dart';

class FarmerChatListScreen extends StatefulWidget {
  @override
  _FarmerChatListScreenState createState() => _FarmerChatListScreenState();
}

class _FarmerChatListScreenState extends State<FarmerChatListScreen> {
  MessageController _messageController = MessageController();
  AppUserController _controller = AppUserController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return StreamBuilder<AppUser>(
      stream: _controller.appUserInfo(_appUser.uid),
      builder: (context, snapshot1) {
        if (snapshot1.hasData) {
          return Scaffold(
            key: _scaffoldKey,
            body: chatRoomList(snapshot1.data),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget chatRoomList(appUser) {
    return StreamBuilder(
      stream: _messageController.getChatRooms(appUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Solve Farmer's Queries",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return chatRoomTile(
                      farmerUid: snapshot.data.docs[index]
                          .data()["ChatRoomId"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(appUser.uid, ""),
                      chatRoomId:
                          snapshot.data.docs[index].data()["ChatRoomId"],
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          print("No Chat Rooms");
          return LoadingWidget();
        }
      },
    );
  }

  Widget chatRoomTile({String farmerUid, String chatRoomId}) {
    return StreamBuilder<AppUser>(
      stream: _controller.appUserInfo(farmerUid),
      builder: (context, farmerSnapshot) {
        if (farmerSnapshot.hasData) {
          final farmer = farmerSnapshot.data;
          return Card(
            elevation: 3.0,
            margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.black,
                backgroundImage: AssetImage('assets/images/farmerUser.png'),
              ),
              title: Text(
                farmer.firstName + " " + farmer.lastName,
              ),
              subtitle: (farmer.city == "")
                  ? Text("")
                  : Text(farmer.city + ", " + farmer.state),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  dynamic result = await showAlertDialog(context,
                      "Are you sure you want to end this conversation?");
                  if (result == true) {
                    await _messageController.deleteChatRoomDocument(chatRoomId);
                    final snackBar = getSnackBar("Conversation ended!");
                    _scaffoldKey.currentState
                      ..removeCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  }
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConversationScreen(
                      chatRoomId: chatRoomId,
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
