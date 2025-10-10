import 'package:flutter/material.dart';
import 'package:weather_app/dep/world_weather.dart';

class ChooseLocation extends StatefulWidget {
  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<WorldWeather> locations = [
    WorldWeather(location: 'Dhaka', flag: 'bd.png', url: 'dhaka'),
    WorldWeather(location: 'Mumbai', flag: 'india.png', url: 'kolkata'),
    WorldWeather(location: 'Karachi', flag: 'pakistan.png', url: 'karachi'),
    WorldWeather(location: 'Jakarta', flag: 'indonesia.png', url: 'jakarta'),
    WorldWeather(location: 'Manila', flag: 'philippines.png', url: 'manila'),
    WorldWeather(location: 'Shanghai', flag: 'china.png', url: 'shanghai'),
    WorldWeather(location: 'Tokyo', flag: 'japan.png', url: 'tokyo'),
    WorldWeather(location: 'Seoul', flag: 'south_korea.png', url: 'seoul'),
    WorldWeather(location: 'New York', flag: 'usa.png', url: 'new_York'),
    WorldWeather(location: 'Los Angeles', flag: 'usa.png', url: 'los_Angeles'),
    WorldWeather(location: 'Chicago', flag: 'usa.png', url: 'chicago'),
    WorldWeather(location: 'Mexico City', flag: 'mexico.png', url: 'mexico_City'),
    WorldWeather(location: 'Rio de Janeiro', flag: 'brazil.png', url: 'sao_Paulo'),
    WorldWeather(location: 'London', flag: 'uk.png', url: 'london'),
    WorldWeather(location: 'Paris', flag: 'france.png', url: 'paris'),
    WorldWeather(location: 'Berlin', flag: 'germany.png', url: 'berlin'),
    WorldWeather(location: 'Rome', flag: 'italy.png', url: 'rome'),
    WorldWeather(location: 'Madrid', flag: 'spain.png', url: 'madrid'),
    WorldWeather(location: 'Istanbul', flag: 'turkey.png', url: 'istanbul'),
    WorldWeather(location: 'Moscow', flag: 'russia.png', url: 'moscow'),
    WorldWeather(location: 'Cairo', flag: 'egypt.png', url: 'cairo'),
    WorldWeather(location: 'Sydney', flag: 'australia.png', url: 'sydney'),
    WorldWeather(location: 'Melbourne', flag: 'australia.png', url: 'melbourne'),
  ];

  void updateWeather(index) async {
    WorldWeather instance = locations[index];
    await instance.getWeather();
    Navigator.pop(context, {
      'location': instance.location,
      'flag': instance.flag,
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/sunny.jpg',
            fit: BoxFit.cover,
            opacity: AlwaysStoppedAnimation(0.4), 
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Color.fromARGB(255, 202, 216, 255).withOpacity(0.7), 
                title: Text(
                  'Choose Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )
                ),
                centerTitle: true,
                elevation: 0.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Card(
                        color: Colors.white.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5.0,
                        child: ListTile(
                          onTap: () {
                            updateWeather(index);
                          },
                          title: Text(
                            locations[index].location,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: AssetImage('assets/${locations[index].flag}'),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
