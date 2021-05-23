import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/controllers/serviceController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/data_layer/models/scheme.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class UpdateSchemeInfoScreen extends StatefulWidget {
  final String schemeId;
  UpdateSchemeInfoScreen({this.schemeId});

  @override
  _UpdateSchemeInfoScreenState createState() => _UpdateSchemeInfoScreenState();
}

class _UpdateSchemeInfoScreenState extends State<UpdateSchemeInfoScreen> {
  ServiceController _serviceController = ServiceController();
  Future<Scheme> _scheme;

  @override
  void initState() {
    super.initState();
    _scheme = getSchemeObj();
  }

  Future<Scheme> getSchemeObj() async {
    return await _serviceController.readScheme(widget.schemeId);
  }

  final _formKey = GlobalKey<FormState>();
  String errMsg;
  File imagePreview;
  bool loading = false;
  AppUserController _controller = AppUserController();

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    // Fetching logged in user information
    return StreamBuilder<AppUser>(
      stream: _controller.appUserInfo(_appUser.uid),
      builder: (context, snapshot) {
        AppUser appUser = snapshot.data;
        if (appUser != null) {
          return Scaffold(
            appBar: myAppBar(context, "Update Scheme Info"),
            body: FutureBuilder(
              future: _scheme,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return buildSchemeInfoFields(context, snapshot.data, appUser);
                } else {
                  return LoadingWidget();
                }
              },
            ),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Widget buildSchemeInfoFields(BuildContext context, scheme, appUser) {
    return loading
        ? LoadingWidget()
        : ListView(
            children: [
              uploadSchemeImage(scheme),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Scheme Name'),
                        validator: (val) =>
                            val.isEmpty ? "Enter scheme name" : null,
                        initialValue: scheme.name,
                        onChanged: (val) {
                          setState(() => scheme.name = val);
                        },
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Scheme Provider'),
                        validator: (val) =>
                            val.isEmpty ? "Enter scheme provider" : null,
                        initialValue: scheme.provider,
                        onChanged: (val) {
                          setState(() => scheme.provider = val);
                        },
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Scheme Details'),
                        validator: (val) => val.isEmpty
                            ? "Enter scheme details in brief"
                            : null,
                        initialValue: scheme.details,
                        onChanged: (val) {
                          setState(() => scheme.details = val);
                        },
                        maxLines: 20,
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Scheme Video Link'),
                        initialValue: scheme.videoLink,
                        onChanged: (val) {
                          setState(() => scheme.videoLink = val);
                        },
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Registration Link'),
                        initialValue: scheme.registrationLink,
                        onChanged: (val) {
                          setState(() => scheme.registrationLink = val);
                        },
                      ),
                      SizedBox(height: 5),
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
                            await _serviceController.writeScheme(
                              schemeId: scheme.schemeId,
                              name: scheme.name,
                              provider: scheme.provider,
                              imageURL: scheme.imageURL,
                              author:
                                  appUser.firstName + " " + appUser.lastName,
                              details: scheme.details,
                              videoLink: scheme.videoLink,
                              registrationLink: scheme.registrationLink,
                              image: scheme.image,
                            );
                            Navigator.pop(
                                context, "Scheme updated successfully!");
                          }
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Widget uploadSchemeImage(scheme) {
    return Column(
      children: [
        SizedBox(height: 5),
        (scheme.imageURL != null)
            ? Image.network(
                scheme.imageURL,
                width: 200,
                height: 220,
              )
            : Image.file(
                scheme.image,
                height: 300,
                width: 300,
              ),
        SizedBox(height: 10),
        GestureDetector(
          child: Container(
            child: Text(
              "Upload Image from Gallery",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
              ),
            ),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * .86,
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.greenAccent, width: 2.0),
            ),
          ),
          onTap: () => uploadImage(scheme),
        ),
      ],
    );
  }

  uploadImage(scheme) async {
    final _picker = ImagePicker();
    PickedFile image;
    // Check for permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      // Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          scheme.image = File(image.path);
          scheme.imageURL = null;
        });
      } else {
        print("No path received");
      }
    } else {
      print("Grant permissions and try again");
    }
  }
}
