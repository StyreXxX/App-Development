import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)!.settings.arguments as Map;
    String bgImage = 'sunny.jpg';

    String resolvedAddress = data['resolvedAddress'] ?? '';
    List<String> addressParts = resolvedAddress.split(',');

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        label: const Text(
                          'Edit Location',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(Icons.edit_location, color: Colors.white),
                        onPressed: () async {
                          dynamic result = await Navigator.pushNamed(context, '/location');
                          setState(() {
                            data = {
                              'resolvedAddress': result['resolvedAddress'],
                              'description': result['description'],
                              'datetime': result['datetime'],
                              'temp': result['temp'],
                              'feelslike': result['feelslike'],
                              'windspeed': result['windspeed'],
                              'conditions': result['conditions'],
                            };
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Text(
                            addressParts[0], 
                            style: GoogleFonts.indieFlower(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            addressParts.length > 1 ? addressParts[1].trim() : '',
                            style: GoogleFonts.indieFlower(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        data['datetime'] ?? 'No datetime',
                        style: GoogleFonts.indieFlower(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Temperature: ${data['temp'] ?? 'No temperature'}°C',
                        style: GoogleFonts.indieFlower(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Feels Like: ${data['feelslike'] ?? 'No feels like'}°C',
                        style: GoogleFonts.indieFlower(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Windspeed: ${data['windspeed'] ?? 'No wind speed'} km/h',
                        style: GoogleFonts.indieFlower(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        data['description'] ?? 'No description',
                        style: GoogleFonts.indieFlower(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
