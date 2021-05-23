import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/data_layer/models/appUserViewModel.dart';
import 'package:kisan_app/src/ui/views/admin/appUserInfo.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/mySnackBar.dart';

import '../../../app.dart';
import '../../routes.dart';

class AppUserListScreen extends StatefulWidget {
  final Function adminNavBar;
  AppUserListScreen({this.adminNavBar});
  @override
  _AppUserListScreenState createState() => _AppUserListScreenState();
}

class _AppUserListScreenState extends State<AppUserListScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  AppUserController _appUserController = AppUserController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: adminAppBar(context),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          displayFarmerList(),
          displayAgriExpertList(),
        ],
      ),
      floatingActionButton: addNewAppUserFAB(context),
      bottomNavigationBar: widget.adminNavBar(),
    );
  }

  Widget displayFarmerList() {
    return FutureBuilder<List<AppUserViewModel>>(
      future: _appUserController.getFarmerList(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: ListView.builder(
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return appUserTile(snapshot.data[index]);
              },
            ),
          );
        }
        return LoadingWidget();
      },
    );
  }

  Widget displayAgriExpertList() {
    return FutureBuilder<List<AppUserViewModel>>(
      future: _appUserController.getAgriExpertList(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: ListView.builder(
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return appUserTile(snapshot.data[index]);
              },
            ),
          );
        }
        return LoadingWidget();
      },
    );
  }

  Widget appUserTile(AppUserViewModel appUser) {
    return Card(
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.black,
          backgroundImage: getAssetImage(appUser),
        ),
        title: Text(appUser.firstName + " " + appUser.lastName),
        subtitle: (appUser.city == "")
            ? Text("")
            : Text(appUser.city + ", " + appUser.state),
        onTap: () async {
          if (appUser != null) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return AppUserInfoScreen(uid: appUser.uid);
              }),
            );
            if (result != null) {
              final snackBar = getSnackBar(result);
              _scaffoldKey.currentState
                ..removeCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          }
        },
      ),
    );
  }

  AssetImage getAssetImage(appUser) {
    if (appUser.accountStatus == true) {
      return (appUser.userType == UniversalConstant.FARMER)
          ? AssetImage('assets/images/farmerUser.png')
          : AssetImage('assets/images/agriExpertUser.png');
    } else {
      return AssetImage('assets/images/deactivatedUser.png');
    }
  }

  adminAppBar(BuildContext context) {
    return AppBar(
      title: Text(UniversalConstant.APP_NAME),
      backgroundColor: Colors.lightGreen[800],
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        tabs: <Tab>[
          Tab(text: UniversalConstant.FARMER),
          Tab(text: UniversalConstant.AGRI_EXPERT),
        ],
      ),
    );
  }

  FloatingActionButton addNewAppUserFAB(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.lightGreen[800],
      foregroundColor: Colors.white,
      onPressed: () => _navigateAndDisplayAddUserScreen(),
    );
  }

  _navigateAndDisplayAddUserScreen() async {
    final result = await Navigator.pushNamed(
      context,
      AppRouter.ADD_NEW_APPUSER_ROUTE,
    );
    if (result != null) {
      final snackBar = getSnackBar(result);
      _scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }
}
