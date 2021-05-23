import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/authController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggle;
  RegisterScreen(this.toggle);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  AuthController _controller = AuthController();

  // text field state
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: _loading ? LoadingWidget() : buildRegistrationFields(context),
    );
  }

  Widget buildRegistrationFields(BuildContext context, {String errMsg}) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                SizedBox(height: 3.0),
                getRegisterImageAsset(),
                SizedBox(height: 3.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'First Name'),
                    validator: (val) => val.isEmpty ? "Enter first name" : null,
                    onChanged: (val) {
                      setState(() => _firstName = val);
                    },
                  ),
                ),
                SizedBox(height: 3.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Last Name'),
                    validator: (val) => val.isEmpty ? "Enter last name" : null,
                    onChanged: (val) {
                      setState(() => _lastName = val);
                    },
                  ),
                ),
                SizedBox(height: 3.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? "Enter an email" : null,
                    onChanged: (val) {
                      setState(() => _email = val);
                    },
                  ),
                ),
                SizedBox(height: 3.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Password'),
                    validator: (val) => val.length < 6
                        ? "Enter a password of atleast 6 characters"
                        : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => _password = val);
                    },
                  ),
                ),
                SizedBox(height: 5.0),
                RaisedButton(
                  color: Colors.lightGreen[800],
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => _loading = true);
                      AppUser result = await _controller.handleUserSignUp(
                        _email,
                        _password,
                        _firstName,
                        _lastName,
                      );
                      if (result == null) {
                        // Navigator.pushReplacementNamed(
                        //   context,
                        //   AppRouter.FARMER_HOME_ROUTE,
                        // );
                        // } else {
                        setState(() {
                          _error = "Email address is already in use";
                          _loading = false;
                        });
                      }
                    }
                  },
                ),
                Text(
                  _error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                RaisedButton(
                  color: Colors.lightGreen[800],
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    widget.toggle();
                  },
                ),
                SizedBox(height: 5.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getRegisterImageAsset() {
    AssetImage assetImage = AssetImage('assets/images/register.png');
    Image image = Image(
      image: assetImage,
      width: 800.0,
      height: 275.0,
    );
    return Container(child: image);
  }
}
