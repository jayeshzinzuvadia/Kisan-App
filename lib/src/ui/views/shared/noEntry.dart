import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/widgets/alertDialogBox.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';
import 'package:provider/provider.dart';

class NoEntryAppUserScreen extends StatefulWidget {
  @override
  _NoEntryAppUserScreenState createState() => _NoEntryAppUserScreenState();
}

class _NoEntryAppUserScreenState extends State<NoEntryAppUserScreen> {
  AppUserController _controller = AppUserController();

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return StreamBuilder<AppUser>(
      stream: _controller.appUserInfo(_appUser.uid),
      builder: (context, snapshot) {
        AppUser appUser = snapshot.data;
        if (appUser != null) {
          return Scaffold(
            appBar: mainAppBar(context),
            body: ListView(
              children: [
                noEntryImage(),
                redTextMessage("No Entry!"),
                redTextMessage("Your account has been deactivated."),
                contactAdmin(),
                deleteAndLogoutButton(context, appUser),
              ],
            ),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Widget contactAdmin() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          "Request admin to activate your account",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget deleteAndLogoutButton(BuildContext context, appUser) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            color: Colors.lightGreen[800],
            child: Container(
              child: Text(
                'Delete My Account',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () async {
              dynamic result = await showAlertDialog(
                  context, "Are you sure you want to delete your account?");
              print(result);
              if (result == true) {
                await _controller.deleteMyAccount(appUser.uid);
                await _controller.handleUserSignOut();
              }
            },
          ),
          SizedBox(width: 10.0),
          RaisedButton(
            color: Colors.lightGreen[800],
            child: Container(
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () async {
              await _controller.handleUserSignOut();
            },
          ),
        ],
      ),
    );
  }

  Padding noEntryImage() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Image.asset(
          "assets/images/noEntry.png",
          height: 410,
          width: 400,
        ),
      ),
    );
  }

  redTextMessage(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 20.0,
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
