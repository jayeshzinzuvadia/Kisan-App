import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/controllers/serviceController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/data_layer/models/scheme.dart';
import 'package:kisan_app/src/ui/views/shared/schemeInfo.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/mySnackBar.dart';
import 'package:provider/provider.dart';
import '../../../app.dart';
import '../../routes.dart';

class SchemeListScreen extends StatefulWidget {
  @override
  _SchemeListScreenState createState() => _SchemeListScreenState();
}

class _SchemeListScreenState extends State<SchemeListScreen> {
  ServiceController _serviceController = ServiceController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUserController _controller = AppUserController();

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return StreamBuilder<AppUser>(
      stream: _controller.appUserInfo(_appUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            key: _scaffoldKey,
            body: displaySchemeList(),
            floatingActionButton:
                (snapshot.data.userType == UniversalConstant.AGRI_EXPERT)
                    ? addNewSchemeFAB(context)
                    : SizedBox.shrink(),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Widget displaySchemeList() {
    return FutureBuilder<List<SchemeViewModel>>(
      future: _serviceController.getSchemeList(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Scheme List",
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
                    return schemeCard(snapshot.data[index]);
                  },
                ),
              ),
            ],
          );
        }
        return LoadingWidget();
      },
    );
  }

  Widget schemeCard(scheme) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: ListTile(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SchemeInfoScreen(
                schemeId: scheme.schemeId,
                videoLink: scheme.videoLink,
              ),
            ),
          );
          if (result != null) {
            final snackBar = getSnackBar(result);
            _scaffoldKey.currentState
              ..removeCurrentSnackBar()
              ..showSnackBar(snackBar);
            setState(() {});
          }
        },
        leading: Hero(
          tag: scheme.schemeId,
          child: Image.network(
            scheme.imageURL,
            height: 100,
            width: 100,
            fit: BoxFit.fill,
          ),
        ),
        title: Text(
          scheme.name,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            "- " + scheme.provider,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton addNewSchemeFAB(BuildContext context) {
    return FloatingActionButton(
      heroTag: "Scheme",
      child: Icon(Icons.add),
      backgroundColor: Colors.lightGreen[800],
      foregroundColor: Colors.white,
      onPressed: () => _navigateToAddNewScheme(),
    );
  }

  _navigateToAddNewScheme() async {
    final result = await Navigator.pushNamed(
      context,
      AppRouter.ADD_NEW_SCHEME_ROUTE,
    );
    if (result != null) {
      final snackBar = getSnackBar(result);
      _scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
      setState(() {});
    }
  }
}
