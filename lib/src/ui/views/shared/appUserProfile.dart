import 'package:flutter/material.dart';
import 'package:kisan_app/src/app.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/views/shared/updateAppUserInfo.dart';
import 'package:kisan_app/src/ui/widgets/alertDialogBox.dart';
import 'package:kisan_app/src/ui/widgets/appUserProfileImage.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/mySnackBar.dart';
import 'package:provider/provider.dart';

class AppUserProfileScreen extends StatefulWidget {
  @override
  _AppUserProfileScreenState createState() => _AppUserProfileScreenState();
}

class _AppUserProfileScreenState extends State<AppUserProfileScreen> {
  AppUserController _controller = AppUserController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return StreamBuilder<AppUser>(
      stream: _controller.appUserInfo(_appUser.uid),
      builder: (context, snapshot) {
        AppUser appUser = snapshot.data;
        if (appUser != null) {
          return Scaffold(
            key: _scaffoldKey,
            body: ListView(
              children: [
                appUserInfo(context, appUser),
                logoutButtonView(context),
                updateAndDeleteButton(appUser),
              ],
            ),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Widget updateAndDeleteButton(appUser) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            color: Colors.lightGreen[800],
            child: Container(
              child: Text(
                'Update Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateAppUserInfoScreen(
                    uid: appUser.uid,
                  ),
                ),
              );
              if (result != null) {
                final snackBar = getSnackBar(result);
                _scaffoldKey.currentState
                  ..removeCurrentSnackBar()
                  ..showSnackBar(snackBar);
              }
            },
          ),
          SizedBox(width: 10.0),
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
        ],
      ),
    );
  }

  Widget salaryAndEducationTiles(appUser) {
    return Column(
      children: [
        divider(),
        ListTile(
          leading: Text(
            ' \u{20B9}', // For indian rupee
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: Colors.lightGreen[800],
            ),
          ),
          title: Text(appUser.salary.toString()),
        ),
        divider(),
        ListTile(
          leading: Icon(Icons.school, color: Colors.lightGreen[800]),
          title: Text(appUser.education),
        ),
      ],
    );
  }

  Widget logoutButtonView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton(
          color: Colors.lightGreen[800],
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.white),
              SizedBox(width: 4.0),
              Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          onPressed: () async {
            await _controller.handleUserSignOut();
            // return Navigator.pushReplacementNamed(
            //   context,
            //   AppRouter.LOGIN_ROUTE,
            // );
          },
        ),
      ],
    );
  }

  Widget appUserInfo(BuildContext context, appUser) {
    return Column(
      children: [
        getProfileImageAsset(appUser.userType),
        SizedBox(height: 5.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Center(
            child: Text(
              appUser.firstName + " " + appUser.lastName,
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Center(
            child: Text(
              "My Profile",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        detailsCard(appUser),
      ],
    );
  }

  Widget detailsCard(appUser) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person, color: Colors.lightGreen[800]),
              title: Text(
                  appUser.gender == UniversalConstant.MALE ? "Male" : "Female"),
            ),
            divider(),
            ListTile(
              leading:
                  Icon(Icons.calendar_today, color: Colors.lightGreen[800]),
              title: Text(dateAndAgeString(appUser.dateOfBirth)),
            ),
            divider(),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.lightGreen[800]),
              title: Text(appUser.mobileNumber.toString()),
            ),
            divider(),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.lightGreen[800]),
              title: Text(getLocationInfo(appUser)),
            ),
            (appUser.userType == UniversalConstant.AGRI_EXPERT)
                ? salaryAndEducationTiles(appUser)
                : Container(),
          ],
        ),
      ),
    );
  }

  String dateAndAgeString(dateOfBirth) {
    return getAgeFromBirthdate(dateOfBirth) +
        " years (" +
        dateOfBirth.day.toString() +
        "/" +
        dateOfBirth.month.toString() +
        "/" +
        dateOfBirth.year.toString() +
        ")";
  }

  String getLocationInfo(appUser) {
    return ((appUser.village != "") ? (appUser.village + ", ") : "") +
        appUser.city +
        ", " +
        appUser.state;
  }

  Widget divider() {
    return Divider(
      height: 0.6,
      color: Colors.black87,
    );
  }

  String getAgeFromBirthdate(DateTime dateOfBirth) {
    final today = DateTime.now();
    final age = today.difference(dateOfBirth).inDays ~/ 365;
    //print("Age is " + age.toString());
    return age.toString();
  }
}
