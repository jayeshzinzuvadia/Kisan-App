import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/controllers/serviceController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class AddNewSchemeScreen extends StatefulWidget {
  @override
  _AddNewSchemeScreenState createState() => _AddNewSchemeScreenState();
}

class _AddNewSchemeScreenState extends State<AddNewSchemeScreen> {
  ServiceController _serviceController = ServiceController();

  final _formKey = GlobalKey<FormState>();
  String _name;
  String _provider;
  String _details;
  String _videoLink;
  String _registrationLink;
  File imagePreview;

  String errMsg = "";
  bool _loading = false;
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
            appBar: myAppBar(context, "Add New Scheme"),
            body: _loading
                ? LoadingWidget()
                : buildSchemeInputFields(context, appUser),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Widget buildSchemeInputFields(BuildContext context, appUser) {
    return ListView(
      children: [
        uploadSchemeImage(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5.0),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Scheme Name'),
                  validator: (val) => val.isEmpty ? "Enter scheme name" : null,
                  onChanged: (val) {
                    setState(() => _name = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Scheme Provider'),
                  validator: (val) =>
                      val.isEmpty ? "Enter scheme provider" : null,
                  onChanged: (val) {
                    setState(() => _provider = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Scheme Details'),
                  validator: (val) =>
                      val.isEmpty ? "Enter scheme details in brief" : null,
                  onChanged: (val) {
                    setState(() => _details = val);
                  },
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Scheme Video Link'),
                  onChanged: (val) {
                    setState(() => _videoLink = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Registration Link'),
                  onChanged: (val) {
                    setState(() => _registrationLink = val);
                  },
                ),
                SizedBox(height: 5),
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
                      await _serviceController.writeScheme(
                        schemeId: "",
                        name: _name,
                        provider: _provider,
                        imageURL: null,
                        author: appUser.firstName + " " + appUser.lastName,
                        details: _details,
                        videoLink: _videoLink,
                        registrationLink: _registrationLink,
                        image: imagePreview,
                      );
                      Navigator.pop(context, "Scheme added successfully!");
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

  Widget uploadSchemeImage() {
    return Column(
      children: [
        SizedBox(height: 5),
        (imagePreview != null)
            ? Image.file(
                imagePreview,
                height: 300,
                width: 300,
              )
            : Image(
                image: AssetImage("assets/images/scheme.png"),
                width: 200,
                height: 220,
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
          onTap: () => uploadImage(),
        ),
      ],
    );
  }

  uploadImage() async {
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
          imagePreview = File(image.path);
        });
      } else {
        print("No path received");
      }
    } else {
      print("Grant permissions and try again");
    }
  }
}
