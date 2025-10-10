import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayerScreen extends StatefulWidget {
  final Map<String, String> song;
  final List<Map<String, String>> songs;
  final int initialIndex;

  const PlayerScreen({
    super.key,
    required this.song,
    required this.songs,
    required this.initialIndex,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double _currentPosition = 0.0;
  double _duration = 1.0;
  late String image;
  late String songFile;
  late String songTitle;
  late String songArtist;

  late int currentSongIndex;

  @override
  void initState() {
    super.initState();
    image = widget.song['image']!;
    songFile = widget.song['file']!;
    songTitle = widget.song['title']!;
    songArtist = widget.song['artist']!;
    currentSongIndex = widget.initialIndex;

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position.inMilliseconds.toDouble();
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration.inMilliseconds.toDouble();
      });
    });

    _playMusic();
  }

  Future<void> _playMusic() async {
    try {
      await _audioPlayer.play(AssetSource('music/$songFile'));
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pauseMusic() async {
    try {
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _seekTo(double value) {
    _audioPlayer.seek(Duration(milliseconds: value.toInt()));
  }

  String _formatTime(double milliseconds) {
    int minutes = (milliseconds / 60000).floor();
    int seconds = ((milliseconds % 60000) / 1000).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _skipNext() {
    setState(() {
      currentSongIndex = (currentSongIndex + 1) % widget.songs.length;
      _updateSongInfo();
    });
    _playMusic();
  }

  void _skipPrevious() {
    setState(() {
      currentSongIndex =
          (currentSongIndex - 1 + widget.songs.length) % widget.songs.length;
      _updateSongInfo();
    });
    _playMusic();
  }

  void _updateSongInfo() {
    final song = widget.songs[currentSongIndex];
    image = song['image']!;
    songFile = song['file']!;
    songTitle = song['title']!;
    songArtist = song['artist']!;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(songTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    songTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    songArtist,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous,
                            size: 40, color: Colors.white),
                        onPressed: _skipPrevious,
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            _pauseMusic();
                          } else {
                            _playMusic();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next,
                            size: 40, color: Colors.white),
                        onPressed: _skipNext,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(_currentPosition),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 300,
                        child: Slider(
                          min: 0.0,
                          max: _duration,
                          activeColor: Colors.grey[900], // Set the active part to black
                          inactiveColor: Colors.grey.withOpacity(0.3),
                          value: _currentPosition,
                          onChanged: (value) {
                            _seekTo(value);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        _formatTime(_duration),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
