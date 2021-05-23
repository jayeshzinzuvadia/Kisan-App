class WeatherResponse {
  final String city;
  final String state;
  final TemperatureInfo tempInfo;
  final WeatherInfo weatherInfo;

  String get iconUrl {
    return "https://openweathermap.org/img/w/${weatherInfo.icon}.png";
  }

  WeatherResponse({this.city, this.state, this.tempInfo, this.weatherInfo});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final city = json['name'];

    final tempInfoJson = json['main'];
    final tempInfo = TemperatureInfo.fromJson(tempInfoJson);

    final weatherInfoJson = json['weather'][0];
    final weatherInfo = WeatherInfo.fromJson(weatherInfoJson);

    return WeatherResponse(
      city: city,
      tempInfo: tempInfo,
      weatherInfo: weatherInfo,
    );
  }
}

class TemperatureInfo {
  final double temperature;
  TemperatureInfo({this.temperature});

  factory TemperatureInfo.fromJson(Map<String, dynamic> json) {
    final temp = json['temp'];
    return TemperatureInfo(temperature: temp);
  }
}

class WeatherInfo {
  final String description;
  final String icon;

  WeatherInfo({this.description, this.icon});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final description = json['description'];
    final icon = json['icon'];
    return WeatherInfo(description: description, icon: icon);
  }
}
