import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/controllers/messageController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/data_layer/models/appUserViewModel.dart';
import 'package:kisan_app/src/ui/views/shared/conversation.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../../app.dart';

class AgriExpertChatListScreen extends StatefulWidget {
  @override
  _AgriExpertChatListScreenState createState() =>
      _AgriExpertChatListScreenState();
}

class _AgriExpertChatListScreenState extends State<AgriExpertChatListScreen> {
  AppUserController _controller = AppUserController();
  MessageController _messageController = MessageController();
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
            body: displayActiveAgriExpertList(snapshot1.data),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Widget displayActiveAgriExpertList(appUser) {
    return FutureBuilder<List<AppUserViewModel>>(
      future: _controller.getActiveAgriExpertList(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Chat with Experts",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: ListView.builder(
                    key: UniqueKey(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return appUserTile(snapshot.data[index], appUser);
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return LoadingWidget();
      },
    );
  }

  Widget appUserTile(AppUserViewModel agriExpert, appUser) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.black,
          backgroundImage: getAssetImage(agriExpert),
        ),
        title: Text(agriExpert.firstName + " " + agriExpert.lastName),
        subtitle: (agriExpert.city == "")
            ? Text("")
            : Text(agriExpert.city + ", " + agriExpert.state),
        onTap: () async {
          if (agriExpert != null) {
            createChatRoomAndStartConversation(
              agriExpertUid: agriExpert.uid,
              farmerUid: appUser.uid,
            );
          }
        },
      ),
    );
  }

  AssetImage getAssetImage(agriExpert) {
    return (agriExpert.userType == UniversalConstant.FARMER)
        ? AssetImage('assets/images/farmerUser.png')
        : AssetImage('assets/images/agriExpertUser.png');
  }

  createChatRoomAndStartConversation({
    String agriExpertUid,
    String farmerUid,
  }) async {
    String chatRoomId = await _messageController.createChatRoom(
      agriExpertUid: agriExpertUid,
      farmerUid: farmerUid,
    );
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(
          chatRoomId: chatRoomId,
        ),
      ),
    );
  }
}
