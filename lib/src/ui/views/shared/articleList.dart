import 'package:flutter/material.dart';
import 'package:kisan_app/src/app.dart';
import 'package:kisan_app/src/controllers/appUserController.dart';
import 'package:kisan_app/src/controllers/serviceController.dart';
import 'package:kisan_app/src/data_layer/models/appUser.dart';
import 'package:kisan_app/src/data_layer/models/article.dart';
import 'package:kisan_app/src/ui/widgets/loading.dart';
import 'package:kisan_app/src/ui/widgets/mySnackBar.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';
import 'articleInfo.dart';

class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  ServiceController _serviceController = ServiceController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  AppUserController _controller = AppUserController();
  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return StreamBuilder<AppUser>(
      stream: _controller.appUserInfo(_appUser.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            key: _scaffoldKey,
            body: displayArticleList(),
            floatingActionButton:
                (snapshot.data.userType == UniversalConstant.AGRI_EXPERT)
                    ? addNewArticleFAB(context)
                    : SizedBox.shrink(),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }

  Widget displayArticleList() {
    return FutureBuilder<List<Article>>(
      future: _serviceController.getArticleList(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Article List",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: ListView.builder(
                  key: UniqueKey(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return articleCard(snapshot.data[index]);
                  },
                ),
              ),
            ],
          );
        }
        return LoadingWidget();
      },
    );
  }

  Widget articleCard(article) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: ListTile(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleInfoScreen(
                articleId: article.articleId,
                videoLink: article.videoLink,
              ),
            ),
          );
          if (result != null) {
            final snackBar = getSnackBar(result);
            _scaffoldKey.currentState
              ..removeCurrentSnackBar()
              ..showSnackBar(snackBar);
            setState(() {});
          }
        },
        leading: Hero(
          tag: article.articleId,
          child: Image.network(
            article.imageURL,
            height: 100,
            width: 100,
            fit: BoxFit.fill,
          ),
        ),
        title: Text(
          article.title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            "- " + article.author,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton addNewArticleFAB(BuildContext context) {
    return FloatingActionButton(
      heroTag: "Article",
      child: Icon(Icons.add),
      backgroundColor: Colors.lightGreen[800],
      foregroundColor: Colors.white,
      onPressed: () => _navigateToAddNewArticle(),
    );
  }

  _navigateToAddNewArticle() async {
    final result = await Navigator.pushNamed(
      context,
      AppRouter.ADD_NEW_ARTICLE_ROUTE,
    );
    if (result != null) {
      final snackBar = getSnackBar(result);
      _scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
      setState(() {});
    }
  }
}
