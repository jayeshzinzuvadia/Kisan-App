import 'package:flutter/material.dart';
import 'package:kisan_app/src/ui/views/admin/updateAppUserInfo.dart';
import 'package:kisan_app/src/ui/views/agriExpert/addNewArticle.dart';
import 'package:kisan_app/src/ui/views/agriExpert/addNewScheme.dart';
import 'package:kisan_app/src/ui/views/shared/schemeInfo.dart';
import 'package:kisan_app/src/ui/views/shared/schemeList.dart';
import 'package:kisan_app/src/ui/views/agriExpert/updateArticleInfo.dart';
import 'package:kisan_app/src/ui/views/agriExpert/updateSchemeInfo.dart';
import 'package:kisan_app/src/ui/views/shared/articleList.dart';
import 'package:kisan_app/src/ui/views/wrapper.dart';
import 'views/admin/addNewAppUser.dart';
import 'views/shared/articleInfo.dart';
import 'views/admin/adminHome.dart';
import 'views/agriExpert/agriExpertHome.dart';
import 'views/farmer/farmerHome.dart';

class AppRouter {
  // Define constant variable here to add the route
  static const INITIAL_ROUTE = '/';
  static const LOGIN_ROUTE = '/login';
  static const REGISTER_ROUTE = '/register';
  static const FARMER_HOME_ROUTE = '/farmerHome';
  static const AGRIEXPERT_HOME_ROUTE = '/agriExpertHome';
  static const ADMIN_HOME_ROUTE = '/adminHome';
  static const ADD_NEW_APPUSER_ROUTE = '/addNewAppUser';
  static const UPDATE_APPUSER_INFO_ROUTE = '/updateAppUserInfo';
  static const SCHEME_LIST_ROUTE = '/schemeList';
  static const ADD_NEW_SCHEME_ROUTE = '/addScheme';
  static const UPDATE_SCHEME_ROUTE = '/updateScheme';
  static const SCHEME_INFO_ROUTE = '/schemeInfo';
  static const ARTICLE_LIST_ROUTE = '/articleList';
  static const ADD_NEW_ARTICLE_ROUTE = '/addArticle';
  static const UPDATE_ARTICLE_ROUTE = '/updateArticle';
  static const ARTICLE_INFO_ROUTE = '/articleInfo';

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case INITIAL_ROUTE:
        return MaterialPageRoute(builder: (_) => Wrapper());
        break;
      case LOGIN_ROUTE:
        return MaterialPageRoute(builder: (_) => Wrapper());
        break;
      case REGISTER_ROUTE:
        return MaterialPageRoute(builder: (_) => Wrapper());
        break;
      case FARMER_HOME_ROUTE:
        return MaterialPageRoute(builder: (_) => FarmerHomeScreen());
        break;
      case AGRIEXPERT_HOME_ROUTE:
        return MaterialPageRoute(builder: (_) => AgriExpertHomeScreen());
        break;
      case ADMIN_HOME_ROUTE:
        return MaterialPageRoute(builder: (_) => AdminHomeScreen());
        break;
      case ADD_NEW_APPUSER_ROUTE:
        return MaterialPageRoute(builder: (_) => AddNewAppUserScreen());
        break;
      case UPDATE_APPUSER_INFO_ROUTE:
        return MaterialPageRoute(builder: (_) => UpdateAppUserScreen());
        break;
      case SCHEME_LIST_ROUTE:
        return MaterialPageRoute(builder: (_) => SchemeListScreen());
        break;
      case SCHEME_INFO_ROUTE:
        return MaterialPageRoute(builder: (_) => SchemeInfoScreen());
        break;
      case ADD_NEW_SCHEME_ROUTE:
        return MaterialPageRoute(builder: (_) => AddNewSchemeScreen());
        break;
      case UPDATE_SCHEME_ROUTE:
        return MaterialPageRoute(builder: (_) => UpdateSchemeInfoScreen());
        break;
      case ARTICLE_LIST_ROUTE:
        return MaterialPageRoute(builder: (_) => ArticleListScreen());
        break;
      case ARTICLE_INFO_ROUTE:
        return MaterialPageRoute(builder: (_) => ArticleInfoScreen());
        break;
      case UPDATE_ARTICLE_ROUTE:
        return MaterialPageRoute(builder: (_) => UpdateArticleInfoScreen());
        break;
      case ADD_NEW_ARTICLE_ROUTE:
        return MaterialPageRoute(builder: (_) => AddNewArticleScreen());
        break;
      default:
        return null;
        break;
    }
  }
}
