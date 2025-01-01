import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/dep/world_weather.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setupWorldWeather() async {
    WorldWeather instance = WorldWeather(
      location: 'Dhaka',
      flag: 'bd.png',
      url: 'dhaka',
    );
    await instance.getWeather();
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'resolvedAddress': instance.resolvedAddress,
      'description': instance.description,
      'datetime': instance.datetime,
      'temp': instance.temp,
      'feelslike': instance.feelslike,
      'windspeed': instance.windspeed,
      'conditions': instance.conditions,
    });
  }

  @override
  void initState() {
    super.initState();
    setupWorldWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitSpinningLines(
              color: Colors.white,
              size: 70.0,
            ),
            SizedBox(height: 20),
            Text(
              'Loading Weather Data...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.8),
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please wait while we fetch the latest weather data.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
