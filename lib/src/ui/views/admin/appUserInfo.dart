import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/views/admin/updateAppUserInfo.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/mySnackBar.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';

import '../../../app.dart';

class AppUserInfoScreen extends StatefulWidget {
  final String uid;
  AppUserInfoScreen({this.uid});

  @override
  _AppUserInfoScreenState createState() => _AppUserInfoScreenState();
}

class _AppUserInfoScreenState extends State<AppUserInfoScreen> {
  final _minimumPadding = 5.0;
  AppUserController _controller = AppUserController();
  Future<AppUser> _appUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _appUser = getAppUserObj();
  }

  Future<AppUser> getAppUserObj() async {
    return await _controller.getAppUserInfo(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: myAppBar(context, "View User Information"),
      body: FutureBuilder(
        future: _appUser,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return userDetails(context, snapshot.data);
          }
          return LoadingWidget();
        },
      ),
    );
  }

  Widget userDetails(BuildContext context, appUser) {
    if (_appUser != null) {
      return ListView(
        children: [
          getProfileImageAsset(appUser),
          displayUserInfo(appUser),
          updateAndDeactivateBtn(appUser),
        ],
      );
    }
    return Container();
  }

  Widget getProfileImageAsset(appUser) {
    AssetImage assetImage;
    if (appUser.accountStatus == true) {
      assetImage = (appUser.userType == UniversalConstant.FARMER)
          ? AssetImage('assets/images/farmerUser.png')
          : AssetImage('assets/images/agriExpertUser.png');
    } else {
      assetImage = AssetImage('assets/images/deactivatedUser.png');
    }
    Image image = Image(
      image: assetImage,
      width: 150.0,
      height: 120.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 3),
    );
  }

  Widget displayUserInfo(appUser) {
    return Column(
      children: [
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
              "User Information",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        detailsCard(appUser),
      ],
    );
  }

  Row updateAndDeactivateBtn(appUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton(
          color: Colors.lightGreen[800],
          child: Container(
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
          ),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateAppUserScreen(
                  uid: appUser.uid,
                );
              }),
            );
            if (result != null) {
              setState(() {
                _appUser = getAppUserObj();
              });
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
              appUser.accountStatus ? 'Deactivate' : 'Activate',
              style: TextStyle(color: Colors.white),
            ),
          ),
          onPressed: () async {
            dynamic result = await _controller.manageAppUserAccount(
                appUser.uid, !appUser.accountStatus);
            if (result) {
              Navigator.pop(
                  context,
                  "User " +
                      ((!appUser.accountStatus) ? "activated" : "deactivated") +
                      " successfully!");
            } else {
              return LoadingWidget();
            }
          },
        ),
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
              title: Text(dateAndAgeString(appUser)),
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

  String dateAndAgeString(appUser) {
    return getAgeFromBirthdate(appUser.dateOfBirth) +
        " years (" +
        appUser.dateOfBirth.day.toString() +
        "/" +
        appUser.dateOfBirth.month.toString() +
        "/" +
        appUser.dateOfBirth.year.toString() +
        ")";
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

  String getLocationInfo(appUser) {
    return ((appUser.village == "") ? "" : (appUser.village + ", ")) +
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
