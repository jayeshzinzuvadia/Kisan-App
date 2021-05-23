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

class AddNewArticleScreen extends StatefulWidget {
  @override
  _AddNewArticleScreenState createState() => _AddNewArticleScreenState();
}

class _AddNewArticleScreenState extends State<AddNewArticleScreen> {
  ServiceController _serviceController = ServiceController();

  final _formKey = GlobalKey<FormState>();
  String _title;
  String _content;
  String _videoLink;
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
            appBar: myAppBar(context, "Add New Article"),
            body: _loading
                ? LoadingWidget()
                : buildArticleInputFields(context, appUser),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Widget buildArticleInputFields(BuildContext context, appUser) {
    return ListView(
      children: [
        uploadArticleImage(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5.0),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Article Title'),
                  validator: (val) =>
                      val.isEmpty ? "Enter article title" : null,
                  onChanged: (val) {
                    setState(() => _title = val);
                  },
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Article Content'),
                  validator: (val) =>
                      val.isEmpty ? "Enter article content in brief" : null,
                  onChanged: (val) {
                    setState(() => _content = val);
                  },
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Article Video Link'),
                  onChanged: (val) {
                    setState(() => _videoLink = val);
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
                      await _serviceController.writeArticle(
                        articleId: "",
                        title: _title,
                        imageURL: null,
                        author: appUser.firstName + " " + appUser.lastName,
                        content: _content,
                        videoLink: _videoLink,
                        image: imagePreview,
                      );
                      Navigator.pop(context, "Article added successfully!");
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

  Widget uploadArticleImage() {
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
                image: AssetImage("assets/images/article.png"),
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
