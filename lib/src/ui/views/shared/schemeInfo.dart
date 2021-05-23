import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:kisan_app/src/app.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/ui/views/agriExpert/updateSchemeInfo.dart';
import 'package:kisan_app/src/ui/widgets/alertDialogBox.dart';
import 'package:kisan_app/src/ui/widgets/mySnackBar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/serviceController.dart';
import 'package:kisan_app/src/data_layer/models/scheme.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';

class SchemeInfoScreen extends StatefulWidget {
  final String schemeId, videoLink;
  SchemeInfoScreen({this.schemeId, this.videoLink});

  @override
  _SchemeInfoScreenState createState() => _SchemeInfoScreenState();
}

class _SchemeInfoScreenState extends State<SchemeInfoScreen> {
  ServiceController _serviceController = ServiceController();
  Future<Scheme> _scheme;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    runYoutubePlayer(widget.videoLink);
    super.initState();
    _scheme = getSchemeObj();
  }

  @override
  void deactivate() {
    if (_youtubePlayerController != null) {
      _youtubePlayerController.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (_youtubePlayerController != null) {
      _youtubePlayerController.dispose();
    }
    super.dispose();
  }

  Future<Scheme> getSchemeObj() async {
    return await _serviceController.readScheme(widget.schemeId);
  }

  AppUserController _controller = AppUserController();

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return StreamBuilder<AppUser>(
      stream: _controller.appUserInfo(_appUser.uid),
      builder: (context, snapshot1) {
        if (snapshot1.hasData) {
          return Scaffold(
            key: _scaffoldKey,
            body: FutureBuilder(
              future: _scheme,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return schemeView(
                      context, snapshot.data, snapshot1.data.userType);
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

  Stack schemeView(BuildContext context, scheme, String userType) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: scheme.schemeId,
                child: Image.network(
                  scheme.imageURL,
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Text(
                      scheme.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "By " + scheme.provider,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    userType == UniversalConstant.AGRI_EXPERT
                        ? updateAndDeleteSchemeButton(scheme)
                        : SizedBox.shrink(),
                    Divider(
                      color: Colors.green,
                      thickness: 2.0,
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text(
                        "Scheme Details:-",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: horizontalLine(),
                    ),
                    schemeDetailsView(scheme),
                    ListTile(
                      leading: Icon(Icons.video_collection_outlined),
                      title: Text(
                        "Video Explanation:-",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: horizontalLine(),
                    ),
                    (scheme.videoLink != null)
                        ? showVideoExplanation(scheme.videoLink)
                        : Container(
                            child: Text("Video content is not available")),
                    ListTile(
                      leading: Icon(Icons.link),
                      title: Text(
                        "Online Registration Link:-",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: horizontalLine(),
                    ),
                    (scheme.registrationLink != null)
                        ? resourceLink(scheme.registrationLink, "to register")
                        : Container(
                            child: Text("Registration link is not available"),
                          ),
                    SizedBox(height: 6),
                    ListTile(
                      leading: Icon(Icons.source),
                      title: Text(
                        "Author: ",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: horizontalLine(),
                    ),
                    Container(
                      child: Text(
                        "- " + scheme.author,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        )
      ],
    );
  }

  Row updateAndDeleteSchemeButton(scheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton(
          color: Colors.lightGreen[800],
          child: Container(
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
          ),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateSchemeInfoScreen(
                  schemeId: scheme.schemeId,
                ),
              ),
            );
            if (result != null) {
              setState(() {
                _scheme = getSchemeObj();
              });
              final snackBar = getSnackBar(result);
              _scaffoldKey.currentState
                ..removeCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          },
        ),
        SizedBox(width: 10.0),
        RaisedButton(
          color: Colors.lightGreen[800],
          child: Container(
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
          onPressed: () async {
            dynamic result = await showAlertDialog(
                context, "Are you sure you want to delete this scheme?");
            if (result == true) {
              _serviceController.deleteScheme(scheme.schemeId);
              Navigator.pop(context, "Scheme deleted successfully!");
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  Divider horizontalLine() {
    return Divider(
      color: Colors.lightGreen,
      thickness: 1,
      endIndent: 25,
    );
  }

  Widget resourceLink(String registrationLink, String message) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: "Click ",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Capriola",
          ),
        ),
        TextSpan(
          text: "here ",
          style: TextStyle(
            color: Colors.blue,
            fontFamily: "Capriola",
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => callbackFunction(registrationLink),
        ),
        TextSpan(
            text: message,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Capriola",
            )),
      ]),
    );
  }

  callbackFunction(String registrationLink) async {
    var url = registrationLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Cannot launch url");
    }
  }

  Widget showVideoExplanation(String videoLink) {
    if (videoLink == "") {
      return Container(child: Text("Video content is not available"));
    } else {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(
          width: MediaQuery.of(context).size.width,
          controller: _youtubePlayerController,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) {
          return Column(
            children: [
              player,
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: resourceLink(videoLink, "to watch"),
              ),
            ],
          );
        },
      );
    }
  }

  runYoutubePlayer(String videoLink) {
    if (videoLink == null || videoLink == "") {
      _youtubePlayerController = null;
    } else {
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoLink),
        flags: YoutubePlayerFlags(
          enableCaption: false,
          autoPlay: false,
        ),
      );
    }
  }

  Widget schemeDetailsView(scheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.lightGreen[50],
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            scheme.details,
            style: TextStyle(
              fontSize: 16.0,
              wordSpacing: 2,
              color: Colors.black87,
            ),
            overflow: TextOverflow.clip,
          ),
        ),
      ),
    );
  }
}
