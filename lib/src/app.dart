import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/views/wrapper.dart';
import 'package:provider/provider.dart';

import 'ui/routes.dart';

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();
  final AppUserController _controller = AppUserController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return StreamProvider<AppUser>.value(
      value: _controller.appUserAuthState,
      child: MaterialApp(
        title: UniversalConstant.APP_NAME,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _appRouter.onGenerateRoute,
        home: Wrapper(),
        theme: ThemeData(
          fontFamily: "Capriola",
          visualDensity: VisualDensity.adaptivePlatformDensity,
          canvasColor: Colors.greenAccent[100],
          primarySwatch: Colors.green,
        ),
      ),
    );
  }
}

// Use this class to add global constants
class UniversalConstant {
  static const APP_NAME = "Kisan App";
  static const FARMER = "Farmer";
  static const AGRI_EXPERT = "Agricultural Expert";
  static const ADMIN = "Admin";
  static const MALE = 0;
  static const FEMALE = 1;
  static const ACTIVATE_ACCOUNT = true;
  static const DEACTIVATE_ACCOUNT = false;
  static const USER_TYPE_LIST = [FARMER, AGRI_EXPERT];
  static const GENDER_LIST = [MALE, FEMALE];
}
