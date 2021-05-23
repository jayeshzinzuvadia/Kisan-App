import 'package:flutter/material.dart';
import 'package:kisan_app/src/app.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../../controllers/appUserController.dart';
import '../../../ui/widgets/styles.dart';

class AdminProfileScreen extends StatefulWidget {
  final Function adminNavBar;
  AdminProfileScreen({this.adminNavBar});

  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  AppUserController _controller = AppUserController();

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    // print(_appUser.uid);
    return StreamBuilder<AppUser>(
      stream: _controller.appUserInfo(_appUser.uid),
      builder: (context, snapshot) {
        AppUser appUser = snapshot.data;
        if (appUser != null) {
          return Scaffold(
            appBar: mainAppBar(context),
            body: ListView(
              children: [
                adminUserInfo(context, appUser),
                adminLogoutButton(context),
              ],
            ),
            bottomNavigationBar: widget.adminNavBar(),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Widget adminUserInfo(context, appUser) {
    return Column(
      children: [
        getProfileImageAsset(),
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

  Widget getProfileImageAsset() {
    AssetImage assetImage;
    assetImage = AssetImage('assets/images/agriExpertUser.png');
    Image image = Image(
      image: assetImage,
      width: 150.0,
      height: 120.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(15),
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

  Row adminLogoutButton(BuildContext context) {
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
}
