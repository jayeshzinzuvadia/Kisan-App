import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import 'admin/adminHome.dart';
import 'agriExpert/agriExpertHome.dart';
import 'authentication/authenticate.dart';
import 'farmer/farmerHome.dart';
import 'shared/noEntry.dart';

class Wrapper extends StatelessWidget {
  final AppUserController _controller = AppUserController();

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    print("Inside wrapper appUser = ");
    print(_appUser);

    //Return either Home or Authenticate widget

    return (_appUser == null)
        ? Authenticate()
        : StreamBuilder<AppUser>(
            stream: _controller.appUserInfo(_appUser.uid),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                final appUser = snapshot.data;
                if (appUser.accountStatus == false) {
                  return NoEntryAppUserScreen();
                } else if (appUser.userType == UniversalConstant.FARMER) {
                  return FarmerHomeScreen();
                } else if (appUser.userType == UniversalConstant.AGRI_EXPERT) {
                  return AgriExpertHomeScreen();
                } else if (appUser.userType == UniversalConstant.ADMIN) {
                  return AdminHomeScreen();
                } else {
                  return LoadingWidget();
                }
              } else {
                return LoadingWidget();
              }
            },
          );
  }
}
