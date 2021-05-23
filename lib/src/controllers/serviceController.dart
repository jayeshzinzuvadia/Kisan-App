import 'dart:io';

import 'package:kisan_app/src/data_layer/models/article.dart';
import 'package:kisan_app/src/data_layer/models/news.dart';
import 'package:kisan_app/src/data_layer/models/scheme.dart';
import 'package:kisan_app/src/data_layer/models/weather.dart';
import 'package:kisan_app/src/data_layer/repository/serviceRepository.dart';

// For news, articles and schemes
class ServiceController {
  ServiceRepository _repository = ServiceRepository();

  // For articles
  Future<void> writeArticle({
    String imageURL,
    String title,
    String content,
    String videoLink,
    String author,
    String articleId,
    File image,
  }) {
    Article article = Article(
      articleId: articleId,
      title: title,
      content: content,
      imageURL: imageURL,
      videoLink: videoLink,
      author: author,
      image: image,
    );
    return _repository.writeArticle(article);
  }

  Future<Article> readArticle(String articleId) {
    return _repository.readArticle(articleId);
  }

  Future<List<Article>> getArticleList() {
    return _repository.getArticleList();
  }

  void deleteArticle(String articleId) {
    return _repository.deleteArticle(articleId);
  }

  // For schemes
  Future<void> writeScheme({
    String name,
    String provider,
    String details,
    String imageURL,
    String videoLink,
    String registrationLink,
    String author,
    String schemeId,
    File image,
  }) {
    Scheme scheme = Scheme(
      schemeId: schemeId,
      name: name,
      provider: provider,
      details: details,
      imageURL: imageURL,
      videoLink: videoLink,
      registrationLink: registrationLink,
      author: author,
      image: image,
    );
    return _repository.writeScheme(scheme);
  }

  Future<Scheme> readScheme(String schemeId) {
    return _repository.readScheme(schemeId);
  }

  Future<List<SchemeViewModel>> getSchemeList() {
    return _repository.getSchemeList();
  }

  void deleteScheme(String schemeId) {
    return _repository.deleteScheme(schemeId);
  }

  // For news
  Future<List<News>> getNewsList() async {
    return await _repository.getNewsList();
  }

  Future<WeatherResponse> getWeatherInfo(String city) async {
    return await _repository.getWeatherInfo(city);
  }
}
