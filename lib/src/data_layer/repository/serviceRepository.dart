import 'package:kisan_app/src/data_layer/models/article.dart';
import 'package:kisan_app/src/data_layer/models/news.dart';
import 'package:kisan_app/src/data_layer/models/scheme.dart';
import 'package:kisan_app/src/data_layer/models/weather.dart';
import 'package:kisan_app/src/data_layer/services/databaseService.dart';
import 'package:kisan_app/src/data_layer/services/newsService.dart';

// Exposing the methods of news, articles and schemes
class ServiceRepository {
  DatabaseService _databaseService = DatabaseService();
  NewsService _newsService = NewsService();

  // For articles
  Future<void> writeArticle(Article article) =>
      _databaseService.writeArticle(article);

  Future<Article> readArticle(String articleId) =>
      _databaseService.readArticle(articleId);

  Future<List<Article>> getArticleList() => _databaseService.articleList;

  void deleteArticle(String articleId) =>
      _databaseService.deleteArticle(articleId);

  // For schemes
  Future<void> writeScheme(Scheme scheme) =>
      _databaseService.writeScheme(scheme);

  Future<Scheme> readScheme(String schemeId) =>
      _databaseService.readScheme(schemeId);

  Future<List<SchemeViewModel>> getSchemeList() => _databaseService.schemeList;

  void deleteScheme(String schemeId) => _databaseService.deleteScheme(schemeId);

  // For news
  Future<List<News>> getNewsList() => _newsService.getNewsList();

  // For weather
  Future<WeatherResponse> getWeatherInfo(String city) =>
      _newsService.getWeatherInfo(city);
}
