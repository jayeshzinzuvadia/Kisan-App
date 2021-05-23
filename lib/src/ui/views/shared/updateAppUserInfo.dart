import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/widgets/appUserProfileImage.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';
import '../../../app.dart';

class UpdateAppUserInfoScreen extends StatefulWidget {
  final String uid;
  UpdateAppUserInfoScreen({this.uid});

  @override
  _UpdateAppUserInfoScreenState createState() =>
      _UpdateAppUserInfoScreenState();
}

class _UpdateAppUserInfoScreenState extends State<UpdateAppUserInfoScreen> {
  AppUserController _controller = AppUserController();
  Future<AppUser> _appUser;

  @override
  void initState() {
    super.initState();
    _appUser = getAppUserObj();
  }

  Future<AppUser> getAppUserObj() async {
    return await _controller.getAppUserInfo(widget.uid);
  }

  final _formKey = GlobalKey<FormState>();
  String errMsg;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "Update User Information"),
      body: FutureBuilder(
        future: _appUser,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return buildAppUserInfoFields(context, snapshot.data);
          }
          return LoadingWidget();
        },
      ),
    );
  }

  ListView buildAppUserInfoFields(BuildContext context, appUser) {
    return ListView(
      children: [
        getProfileImageAsset(appUser.userType),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5.0),
                userNameTextField(appUser),
                SizedBox(height: 5.0),
                selectGenderField(appUser),
                SizedBox(height: 5.0),
                inputBirthDatePicker(appUser),
                SizedBox(height: 5.0),
                mobileNumberField(appUser),
                SizedBox(height: 5.0),
                locationField(appUser),
                RaisedButton(
                  color: Colors.lightGreen[800],
                  child: Text(
                    "Update",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      bool result =
                          await _controller.updateAppUserInfo(appUser);
                      if (result == true) {
                        Navigator.pop(
                            context, "User data updated successfully!");
                      }
                    }
                  },
                ),
                SizedBox(height: 5.0),
                Text(
                  errMsg ?? '',
                  style: validationMessageTextStyle(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget locationField(appUser) {
    return Column(
      children: [
        TextFormField(
          initialValue: appUser.village,
          decoration: textInputDecoration.copyWith(hintText: 'Village'),
          onChanged: (val) {
            setState(() => appUser.village = val);
          },
        ),
        SizedBox(height: 5.0),
        TextFormField(
          initialValue: appUser.city,
          decoration: textInputDecoration.copyWith(hintText: 'City'),
          validator: (val) => val.isEmpty ? "Enter name of city" : null,
          onChanged: (val) {
            setState(() => appUser.city = val);
          },
        ),
        SizedBox(height: 5.0),
        TextFormField(
          initialValue: appUser.state,
          decoration: textInputDecoration.copyWith(hintText: 'State'),
          validator: (val) => val.isEmpty ? "Enter name of state" : null,
          onChanged: (val) {
            setState(() => appUser.state = val);
          },
        )
      ],
    );
  }

  TextFormField mobileNumberField(appUser) {
    return TextFormField(
      initialValue:
          appUser.mobileNumber == 0 ? "" : appUser.mobileNumber.toString(),
      decoration: textInputDecoration.copyWith(hintText: 'Mobile Number'),
      validator: (val) => val.isEmpty ? "Enter mobile number" : null,
      onChanged: (val) {
        setState(() => appUser.mobileNumber = int.parse(val));
      },
      keyboardType: TextInputType.phone,
    );
  }

  Widget userNameTextField(appUser) {
    return Column(
      children: [
        TextFormField(
          initialValue: appUser.firstName,
          decoration: textInputDecoration.copyWith(hintText: 'First Name'),
          validator: (val) => val.isEmpty ? "Enter first name" : null,
          onChanged: (val) {
            setState(() => appUser.firstName = val);
          },
        ),
        SizedBox(height: 5),
        TextFormField(
          initialValue: appUser.lastName,
          decoration: textInputDecoration.copyWith(hintText: 'Last Name'),
          validator: (val) => val.isEmpty ? "Enter last name" : null,
          onChanged: (val) {
            setState(() => appUser.lastName = val);
          },
        ),
      ],
    );
  }

  DropdownButtonFormField<Object> selectGenderField(appUser) {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      items: UniversalConstant.GENDER_LIST.map((int dropDownStringItem) {
        return DropdownMenuItem<int>(
          value: dropDownStringItem,
          child: Text(
            (dropDownStringItem == UniversalConstant.MALE) ? "Male" : "Female",
          ),
        );
      }).toList(),
      value: appUser.gender,
      validator: (val) => val == null ? 'Select Gender' : null,
      onChanged: (val) {
        setState(() => appUser.gender = val);
      },
      decoration: textInputDecoration.copyWith(hintText: 'Gender'),
    );
  }

  formatBirthDate(DateTime date) {
    return date.day.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.year.toString();
  }

  Widget inputBirthDatePicker(appUser) {
    return GestureDetector(
      child: Container(
        child: Text(
          (appUser.dateOfBirth == null)
              ? "Date of Birth"
              : formatBirthDate(appUser.dateOfBirth),
          style: TextStyle(
            color:
                (appUser.dateOfBirth == null) ? Colors.black54 : Colors.black,
            fontSize: 16.0,
          ),
        ),
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.greenAccent, width: 2.0),
        ),
      ),
      onTap: () {
        return showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime(2050),
          initialDate: appUser.dateOfBirth,
          fieldLabelText: "Date Of Birth",
        ).then((dob) {
          setState(() {
            appUser.dateOfBirth = dob;
          });
        });
      },
    );
  }
}
