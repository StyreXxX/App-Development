import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldWeather {
  String location;
  String flag;
  String url;
  late String resolvedAddress;
  late String description;
  late String datetime;
  late double temp;
  late double feelslike;
  late double windspeed;
  late String conditions;

  WorldWeather({
    required this.location,
    required this.flag,
    required this.url,
  });
  Future<void> getWeather() async {
    try {
      Response response = await get(Uri.parse(
          'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$url?unitGroup=metric&include=current&key=5N9ZQAKJ3796Q8N9JWUCGNSXY&contentType=json'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        
        resolvedAddress = data['resolvedAddress'] ?? 'Unknown Location';
        
        if (data['days'] != null && data['days'].isNotEmpty) {
          Map<String, dynamic> dayData = data['days'][0]; 
          
          description = dayData['description'] ?? 'No Description';
          datetime = dayData['datetime'] ?? 'Unknown Date';
          temp = (dayData['temp'] ?? 0).toDouble();
          feelslike = (dayData['feelslike'] ?? 0).toDouble();
          windspeed = (dayData['windspeed'] ?? 0).toDouble();
          conditions = dayData['conditions'] ?? 'Unknown Conditions';
        } else {
          throw Exception("Key 'days' is missing or empty in API response.");
        }
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}
