import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; //location name for the UI
  String time = ""; //time for the location
  String flag; //url to an asset file icon
  String url;
  late bool isdaytime; //true or false if daytime or not

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    Response response = await get(Uri.parse(
        'https://www.timeapi.io/api/Time/current/zone?timeZone=$url'));
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        String dateTime = data['dateTime'];
        //String Time = data['time'];
        //print(dateTime);
        //print(Time);
        DateTime now = DateTime.parse(dateTime);
        //set time property
        isdaytime = now.hour > 6 && now.hour < 20 ? true : false;
        time = DateFormat.jm().format(now);
        //print(now);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('error: $e');
    }
  }
}
