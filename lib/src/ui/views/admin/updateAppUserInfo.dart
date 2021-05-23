import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';
import '../../../app.dart';

class UpdateAppUserScreen extends StatefulWidget {
  final String uid;
  UpdateAppUserScreen({this.uid});
  @override
  _UpdateAppUserScreenState createState() => _UpdateAppUserScreenState();
}

class _UpdateAppUserScreenState extends State<UpdateAppUserScreen> {
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

  final _minimumPadding = 5.0;
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
        getProfileImageAsset(appUser),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5.0),
                selectUserType(appUser),
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
                salaryAndEducationFields(appUser),
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
                      } else {
                        setState(() {
                          errMsg = "Email address is already in use";
                          loading = false;
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

  DropdownButtonFormField<String> selectUserType(appUser) {
    return DropdownButtonFormField(
      dropdownColor: Colors.white,
      items: UniversalConstant.USER_TYPE_LIST.map((String dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      value: appUser.userType,
      validator: (val) => val == null ? 'Select User Type' : null,
      onChanged: (val) {
        setState(() {
          appUser.userType = val;
        });
      },
      decoration: textInputDecoration.copyWith(hintText: 'User Type'),
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

  Widget salaryAndEducationFields(appUser) {
    if (appUser.userType == UniversalConstant.FARMER) {
      return SizedBox(height: 5.0);
    }
    return Column(
      children: [
        SizedBox(height: 5.0),
        TextFormField(
          initialValue: (appUser.salary == 0) ? "" : appUser.salary.toString(),
          decoration: textInputDecoration.copyWith(hintText: 'Salary'),
          validator: (val) => val == "0" || val == null ? "Enter salary" : null,
          onChanged: (val) {
            setState(() => appUser.salary = int.parse(val));
          },
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 5.0),
        TextFormField(
          initialValue: appUser.education,
          decoration: textInputDecoration.copyWith(hintText: 'Education'),
          validator: (val) => val.isEmpty ? "Enter education details" : null,
          onChanged: (val) {
            setState(() => appUser.education = val);
          },
        ),
        SizedBox(height: 5.0),
      ],
    );
  }
}
