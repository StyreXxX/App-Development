import 'package:flutter/material.dart';
import 'package:music_player/screens/Player/player.dart';

class ChillScreen extends StatefulWidget {
  const ChillScreen({super.key});

  @override
  State<ChillScreen> createState() => _ChillScreenState();
}

class _ChillScreenState extends State<ChillScreen> {
  final List<Map<String, String>> songs = [
    {
      'title': 'Love Story',
      'artist': 'Indila',
      'image': 'assets/images/Indila.jpg',
      'file': 'LoveStory.m4a', 
    },
    {
      'title': 'Dangerously',
      'artist': 'Olivia Adams',
      'image': 'assets/images/Danger.jpg',
      'file': 'Dangerously.m4a', 
    },
    {
      'title': 'Lush Life',
      'artist': 'Zara Larrson',
      'image': 'assets/images/LushLife.png',
      'file': 'LushLife.m4a', 
    },
    {
      'title': 'Safari',
      'artist': 'Serena',
      'image': 'assets/images/Safari.jpg',
      'file': 'Safari.m4a', 
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chill Vibes'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
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
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return Card(
                      color: Colors.black.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(song['image']!),
                          radius: 28,
                        ),
                        title: Text(
                          song['title']!,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        subtitle: Text(
                          song['artist']!,
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.play_arrow, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayerScreen(
                                  song: song,
                                  songs: songs,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
