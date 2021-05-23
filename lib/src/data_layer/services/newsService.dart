import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kisan_app/src/data_layer/models/news.dart';
import 'package:kisan_app/src/data_layer/models/weather.dart';
import 'package:kisan_app/src/data_layer/services/constants.dart';

class NewsService {
  //api.openweathermap.org/data/2.5/weather?q={city name},{state code},{country code}&appid={API key}
  Future<WeatherResponse> getWeatherInfo(String city) async {
    final queryParameters = {
      'q': city,
      'appid': URLConstant.OPEN_WEATHER_MAP_APP_ID,
      'units': 'metric',
    };

    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);
    final response = await http.get(uri);

    print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }

  Future<List<News>> getNewsList() async {
    List<News> newsList = [];
    var response = await http.get(URLConstant.GNEWS_API_URL);
    var jsonData = jsonDecode(response.body);

    if (jsonData['totalArticles'] != 0) {
      // Iterating over each news article and adding it to the news list
      jsonData['articles'].forEach((element) {
        if (element['image'] != null && element['description'] != null) {
          News news = News(
            title: element['title'],
            description: element['description'],
            source: element['source']['name'],
            url: element['url'],
            image: element['image'],
            publishedAt: element['publishedAt'],
            content: element['content'],
          );
          newsList.add(news);
        }
      });
    }
    return newsList;
  }
}
