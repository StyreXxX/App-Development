import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data =data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;
    print(data);

    //set background
    String bgImage = data['isdaytime'] ? 'day.jpg' : 'night.jpg';
    Color bgColor = data['isdaytime'] ? Colors.lightBlueAccent : Colors.indigo;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/$bgImage'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
          child: Column(
            children: <Widget>[
              TextButton.icon(
                onPressed: () async {
                  dynamic result = await Navigator.pushNamed(
                    context,
                    '/location',
                  );
                  setState(() {
                    data = {
                      'time': result['time'],
                      'location': result['location'],
                      'isdaytime': result['isdaytime'],
                      'flag': result['flag'],
                    };
                  });
                },
                icon: Icon(
                  Icons.edit_location,
                  color: Colors.grey[300],
                ),
                label: Text(
                  'Edit Location',
                  style: TextStyle(
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(data['location'],
                      style: TextStyle(
                        fontSize: 30,
                        letterSpacing: 2,
                        color: Colors.white,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
              SizedBox(height: 20),
              Text(
                data['time'],
                style: TextStyle(
                  fontSize: 80, // Larger and bold for prominence
                  fontWeight: FontWeight.bold, // Strong emphasis
                  color: Colors.white, // Keep it clean
                  fontFamily: 'Arimo', // Use a stylish font like Raleway or add your own
                  letterSpacing: 3.0, // Moderate spacing for balance
                  shadows: [
                    Shadow(
                      blurRadius: 15.0,
                      color: Colors.black87, // Strong shadow for better contrast
                      offset: Offset(3.0, 3.0), // Slight offset for depth
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),



            ],
          ),
        ),
      )),
    );
  }
}
