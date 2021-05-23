import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/controllers/serviceController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/data_layer/models/article.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class UpdateArticleInfoScreen extends StatefulWidget {
  final String articleId;
  UpdateArticleInfoScreen({this.articleId});
  @override
  _UpdateArticleInfoScreenState createState() =>
      _UpdateArticleInfoScreenState();
}

class _UpdateArticleInfoScreenState extends State<UpdateArticleInfoScreen> {
  ServiceController _serviceController = ServiceController();
  Future<Article> _article;

  @override
  void initState() {
    super.initState();
    _article = getArticleObj();
  }

  Future<Article> getArticleObj() async {
    return await _serviceController.readArticle(widget.articleId);
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
            appBar: myAppBar(context, "Update Article Info"),
            body: FutureBuilder(
              future: _article,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return buildArticleInfoFields(
                      context, snapshot.data, appUser);
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

  Widget buildArticleInfoFields(BuildContext context, article, appUser) {
    return loading
        ? LoadingWidget()
        : ListView(
            children: [
              uploadArticleImage(article),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Article Title'),
                        validator: (val) =>
                            val.isEmpty ? "Enter article title" : null,
                        initialValue: article.title,
                        onChanged: (val) {
                          setState(() => article.title = val);
                        },
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Article Content'),
                        validator: (val) => val.isEmpty
                            ? "Enter article content in brief"
                            : null,
                        initialValue: article.content,
                        onChanged: (val) {
                          setState(() => article.content = val);
                        },
                        maxLines: 20,
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(height: 5.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Article Video Link'),
                        initialValue: article.videoLink,
                        onChanged: (val) {
                          setState(() => article.videoLink = val);
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
                            await _serviceController.writeArticle(
                              articleId: article.articleId,
                              title: article.title,
                              imageURL: article.imageURL,
                              author:
                                  appUser.firstName + " " + appUser.lastName,
                              content: article.content,
                              videoLink: article.videoLink,
                              image: article.image,
                            );
                            Navigator.pop(
                                context, "Article updated successfully!");
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

  Widget uploadArticleImage(article) {
    return Column(
      children: [
        SizedBox(height: 5),
        (article.imageURL != null)
            ? Image.network(
                article.imageURL,
                width: 200,
                height: 220,
              )
            : Image.file(
                article.image,
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
          onTap: () => uploadImage(article),
        ),
      ],
    );
  }

  uploadImage(article) async {
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
          article.image = File(image.path);
          article.imageURL = null;
        });
      } else {
        print("No path received");
      }
    } else {
      print("Grant permissions and try again");
    }
  }
}
