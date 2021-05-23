import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';

import '../../../app.dart';

class AddNewAppUserScreen extends StatefulWidget {
  @override
  _AddNewAppUserScreenState createState() => _AddNewAppUserScreenState();
}

class _AddNewAppUserScreenState extends State<AddNewAppUserScreen> {
  AppUserController _controller = AppUserController();

  // text field state
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  String _userType = '';
  String _city = '';
  String _state = '';
  String _village = '';
  int _gender = 0;
  DateTime _dateOfBirth;
  int _salary = 0;
  String _education = "";
  int _mobileNumber = 0;

  final _minimumPadding = 5.0;
  String errMsg = "";
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _userFlag = true;

  @override
  Widget build(BuildContext bcontext) {
    return Scaffold(
      appBar: myAppBar(context, "Add New User"),
      body: _loading ? LoadingWidget() : buildAppUserInfoFields(context),
    );
  }

  ListView buildAppUserInfoFields(BuildContext context) {
    return ListView(
      children: [
        getProfileImageAsset(_userFlag),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5.0),
                selectUserType(),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: 'First Name'),
                  validator: (val) => val.isEmpty ? "Enter first name" : null,
                  onChanged: (val) {
                    setState(() => _firstName = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Last Name'),
                  validator: (val) => val.isEmpty ? "Enter last name" : null,
                  onChanged: (val) {
                    setState(() => _lastName = val);
                  },
                ),
                SizedBox(height: 5.0),
                DropdownButtonFormField(
                  dropdownColor: Colors.white,
                  items: UniversalConstant.GENDER_LIST
                      .map((int dropDownStringItem) {
                    return DropdownMenuItem<int>(
                      value: dropDownStringItem,
                      child: Text(
                        (dropDownStringItem == UniversalConstant.MALE)
                            ? "Male"
                            : "Female",
                      ),
                    );
                  }).toList(),
                  validator: (val) => val == null ? 'Select Gender' : null,
                  onChanged: (val) {
                    setState(() => _gender = val);
                  },
                  decoration: textInputDecoration.copyWith(hintText: 'Gender'),
                ),
                SizedBox(height: 5.0),
                inputBirthDatePicker(),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Mobile Number'),
                  validator: (val) =>
                      val.isEmpty ? "Enter mobile number" : null,
                  onChanged: (val) {
                    setState(() => _mobileNumber = int.parse(val));
                  },
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Village'),
                  // validator: (val) => val.isEmpty ? "Enter name of city" : null,
                  onChanged: (val) {
                    setState(() => _village = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'City'),
                  validator: (val) => val.isEmpty ? "Enter name of city" : null,
                  onChanged: (val) {
                    setState(() => _city = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'State'),
                  validator: (val) =>
                      val.isEmpty ? "Enter name of state" : null,
                  onChanged: (val) {
                    setState(() => _state = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val.isEmpty ? "Enter an email" : null,
                  onChanged: (val) {
                    setState(() => _email = val);
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 5.0),
                TextFormField(
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
                salaryAndEducationFields(_userFlag),
                RaisedButton(
                  color: Colors.lightGreen[800],
                  child: Text(
                    "Add",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => _loading = true);
                      dynamic result = await _controller.addNewUserByAdmin(
                        _email,
                        _password,
                        _firstName,
                        _lastName,
                        userType: _userType,
                        gender: _gender,
                        dateOfBirth: _dateOfBirth,
                        mobileNumber: _mobileNumber,
                        village: _village,
                        city: _city,
                        state: _state,
                        salary: _salary,
                        education: _education,
                      );
                      if (result != null) {
                        Navigator.pop(
                            context, "New user created successfully!");
                      } else {
                        setState(() {
                          errMsg = "Email address is already in use";
                          _loading = false;
                        });
                      }
                    }
                  },
                ),
                SizedBox(height: 5.0),
                Text(
                  errMsg ?? '',
                  style: validationMessageTextStyle(),
                ),
                SizedBox(height: 5.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  DropdownButtonFormField<String> selectUserType() {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      items: UniversalConstant.USER_TYPE_LIST.map((String dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      validator: (val) => val == null ? 'Select User Type' : null,
      onChanged: (val) {
        setState(() {
          _userType = val;
          _userFlag = (val == UniversalConstant.FARMER) ? true : false;
        });
      },
      decoration: textInputDecoration.copyWith(hintText: 'User Type'),
    );
  }

  Widget getProfileImageAsset(bool userFlag) {
    AssetImage assetImage = (userFlag)
        ? AssetImage('assets/images/farmerUser.png')
        : AssetImage('assets/images/agriExpertUser.png');
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

  formatBirthDate(DateTime date) {
    return date.day.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.year.toString();
  }

  Widget inputBirthDatePicker() {
    return GestureDetector(
      child: Container(
        child: Text(
          (_dateOfBirth == null)
              ? "Date of Birth"
              : formatBirthDate(_dateOfBirth),
          style: TextStyle(
            color: (_dateOfBirth == null) ? Colors.black54 : Colors.black,
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
          initialDate: DateTime.now(),
          fieldLabelText: "Date Of Birth",
        ).then((dob) {
          setState(() {
            _dateOfBirth = dob;
          });
        });
      },
    );
  }

  Widget salaryAndEducationFields(bool userFlag) {
    if (userFlag == true) {
      return SizedBox(height: 5.0);
    }
    return Column(
      children: [
        SizedBox(height: 5.0),
        TextFormField(
          decoration: textInputDecoration.copyWith(hintText: 'Salary'),
          validator: (val) => val.isEmpty ? "Enter salary" : null,
          onChanged: (val) {
            setState(() => _salary = int.parse(val));
          },
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          decoration: textInputDecoration.copyWith(hintText: 'Education'),
          validator: (val) => val.isEmpty ? "Enter education details" : null,
          onChanged: (val) {
            setState(() => _education = val);
          },
        ),
      ],
    );
  }
}
