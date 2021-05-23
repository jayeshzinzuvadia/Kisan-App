import 'package:flutter/material.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/controllers/serviceController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/data_layer/models/news.dart';
import 'package:kisan_app/src/data_layer/models/weather.dart';
import 'package:kisan_app/src/ui/views/shared/newsWebView.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  ServiceController _serviceController = ServiceController();
  AppUserController _controller = AppUserController();

  Future<List<News>> _newsList;

  @override
  void initState() {
    super.initState();
    _newsList = _serviceController.getNewsList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildWeatherReport(context),
        newsHeadlineTitle(),
        buildNewsList(context),
      ],
    );
  }

  Widget newsHeadlineTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        "Agricultural News",
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildWeatherReport(context) {
    final _appUser = Provider.of<AppUser>(context);
    return StreamBuilder<AppUser>(
      stream: _controller.appUserInfo(_appUser.uid),
      builder: (context, snapshot1) {
        if (snapshot1.hasData) {
          return FutureBuilder<WeatherResponse>(
            future: _serviceController.getWeatherInfo(snapshot1.data.city),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 2.0,
                    child: Column(
                      children: [
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Weather Report of " + snapshot1.data.city,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatDescription(
                                      snapshot.data.weatherInfo.description),
                                  style: TextStyle(
                                    color: Colors.lightGreen[900],
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Temperature : " +
                                      snapshot.data.tempInfo.temperature
                                          .toString() +
                                      "\u00B0C",
                                  style: TextStyle(
                                    color: Colors.lightGreen[900],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Container(
                            child: Image.network(snapshot.data.iconUrl),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  String formatDescription(str) {
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }

  Widget buildNewsList(context) {
    return FutureBuilder<List<News>>(
      future: _newsList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return NewsTile(
                imageURL: snapshot.data[index].image,
                title: snapshot.data[index].title,
                description: snapshot.data[index].description,
                publishedAt: snapshot.data[index].publishedAt,
                content: snapshot.data[index].content,
                url: snapshot.data[index].url,
                source: snapshot.data[index].source,
              );
            },
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }
}

class NewsTile extends StatelessWidget {
  final String imageURL, title, description, publishedAt, content, url, source;

  NewsTile({
    @required this.imageURL,
    @required this.title,
    @required this.description,
    @required this.publishedAt,
    this.content,
    this.url,
    this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsWebViewScreen(
                url: url,
              ),
            ),
          );
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 2.0,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Image.network(imageURL),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    wordSpacing: 4.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                    wordSpacing: 2.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    printDate(publishedAt),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.lightGreen[900],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String printDate(dateString) {
    return DateFormat.yMMMMEEEEd().format(DateTime.parse(dateString));
  }
}
