import 'package:flutter/material.dart';
import '../../../ui/widgets/loading.dart';
import '../../../controllers/authController.dart';
import '../../../data_layer/models/appUser.dart';
import '../../../ui/widgets/styles.dart';
import '../../../app.dart';
import '../../routes.dart';

class LoginScreen extends StatefulWidget {
  final Function toggle;
  LoginScreen(this.toggle);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();
  AuthController _controller = AuthController();

  // text field state
  String _email = '';
  String _password = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: _loading ? LoadingWidget() : buildLoginView(context),
    );
  }

  Widget buildLoginView(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                getFarmerImageAsset(),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? "Enter an email" : null,
                    onChanged: (val) {
                      setState(() => _email = val);
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Password'),
                    validator: (val) =>
                        val.length < 6 ? "Enter a password" : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => _password = val);
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  color: Colors.lightGreen[800],
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => _loading = true);
                      dynamic result =
                          await _controller.handleUserSignIn(_email, _password);
                      if (result == null) {
                        setState(() {
                          _error = 'Incorrect Email or Password';
                          _loading = false;
                        });
                      }
                      // else {
                      //   return await navigateToAppUserHomeScreen(result);
                      // }
                    }
                  },
                ),
                Text(
                  _error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                RaisedButton(
                  color: Colors.lightGreen[800],
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    widget.toggle();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getFarmerImageAsset() {
    AssetImage assetImage = AssetImage('assets/images/farmer.png');
    Image image = Image(
      image: assetImage,
      width: 800.0,
      height: 300.0,
    );
    return Container(child: image);
  }

  navigateToAppUserHomeScreen(AppUser appUser) {
    print("Inside navigate method - AppUser " + appUser.toString());
    if (appUser.userType == UniversalConstant.FARMER) {
      return Navigator.pushReplacementNamed(
        context,
        AppRouter.FARMER_HOME_ROUTE,
      );
    } else if (appUser.userType == UniversalConstant.AGRI_EXPERT) {
      return Navigator.pushReplacementNamed(
        context,
        AppRouter.AGRIEXPERT_HOME_ROUTE,
      );
    } else if (appUser.userType == UniversalConstant.ADMIN) {
      return Navigator.pushReplacementNamed(
        context,
        AppRouter.ADMIN_HOME_ROUTE,
      );
    }
  }
}
