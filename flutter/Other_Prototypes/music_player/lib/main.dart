import 'package:flutter/material.dart';
import 'package:music_player/screens/chill.dart';
import 'package:music_player/screens/jazz.dart';
import 'package:music_player/screens/party.dart';
import 'package:music_player/screens/relax.dart';
import 'package:music_player/screens/top50.dart';
import 'package:music_player/screens/workout.dart';

void main() => runApp(MaterialApp(
  home: MusicPlayer(),
  debugShowCheckedModeBanner: false,
));

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  String currentSong = "No song playing";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(1), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search music, artists, playlists...',
                          hintStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Welcome to Music Player',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            _buildButton('Chill Vibes',
                                'assets/images/chill.jpg', 'chill'),
                            _buildButton('Workout Hits',
                                'assets/images/workout.jpg', 'workout'),
                            _buildButton(
                                'Top 50', 'assets/images/top50.jpg', 'top50'),
                            _buildButton('Jazz Classics',
                                'assets/images/jazz.jpg', 'jazz'),
                            _buildButton('Party Mix', 'assets/images/party.jpg',
                                'party'),
                            _buildButton('Relax & Unwind',
                                'assets/images/relax.jpg', 'relax'),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(8.0),
                      //   decoration: BoxDecoration(
                      //     color: Colors.black.withOpacity(0.7),
                      //     borderRadius: BorderRadius.circular(8.0),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       CircleAvatar(
                      //         backgroundImage:
                      //             AssetImage('assets/images/Danger.jpg'),
                      //         radius: 24,
                      //       ),
                      //       SizedBox(width: 12),
                      //       Expanded(
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               currentSong,
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //             Text(
                      //               'Artist Name',
                      //               style: TextStyle(color: Colors.white70),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       Icon(Icons.play_arrow, color: Colors.white),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  }
  Widget _buildButton(String title, String imagePath, String buttonId) {
    return GestureDetector(
      onTap: () {
        if (buttonId == 'chill') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChillScreen()),
          );
          setState(() {
            currentSong = 'Chill Vibes';
          });
        } else if (buttonId == 'workout') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkoutScreen()),
          );
          setState(() {
            currentSong = 'Workout Hits';
          });
        } else if (buttonId == 'top50') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Top50Screen()),
          );
          setState(() {
            currentSong = 'Top 50';
          });
        } else if (buttonId == 'jazz') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JazzScreen()),
          );
          setState(() {
            currentSong = 'Jazz Classics';
          });
        } else if (buttonId == 'party') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PartyScreen()),
          );
          setState(() {
            currentSong = 'Party Mix';
          });
        } else if (buttonId == 'relax') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RelaxScreen()),
          );
          setState(() {
            currentSong = 'Relax & Unwind';
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}