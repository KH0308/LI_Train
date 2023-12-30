class Weather {
  final String dateTime;
  final String cityName;
  final String countryName; // Updated property name
  final double temperature; // Updated property name
  final String mainConditionText;
  final String mainConditionImg;

  Weather({
    required this.dateTime,
    required this.cityName,
    required this.countryName,
    required this.temperature,
    required this.mainConditionText,
    required this.mainConditionImg,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      dateTime: json['current']['last_updated'].toString(),
      cityName: json['location']['name'],
      countryName: json['location']['country'],
      temperature: json['current']['temp_c'].toDouble(),
      mainConditionText: json['current']['condition']['text'],
      mainConditionImg: 'https:' + json['current']['condition']['icon'],
    );
  }
}
