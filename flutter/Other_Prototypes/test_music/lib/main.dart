import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double _currentPosition = 0.0;
  double _duration = 1.0;
  int _currentTrackIndex = 0;
  late String image;

  final List<String> _songs = ['test.m4a', 'danger.m4a'];
  final List<String> images = ['Indila', 'Danger']; 

  Future<void> _playMusic() async {
    try {
      await _audioPlayer.play(AssetSource(_songs[_currentTrackIndex]));
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

  void _skipNext() {
    setState(() {
      _currentTrackIndex = (_currentTrackIndex + 1) % _songs.length;
      image = images[_currentTrackIndex]; 
    });
    _playMusic();
  }

  void _skipBack() {
    setState(() {
      _currentTrackIndex = (_currentTrackIndex - 1) % _songs.length;
      image = images[_currentTrackIndex]; 
    });
    _playMusic();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    image = images[_currentTrackIndex]; 
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
  }

  void _seekTo(double value) {
    _audioPlayer.seek(Duration(milliseconds: value.toInt()));
  }

  String _formatTime(double milliseconds) {
    int minutes = (milliseconds / 60000).floor();
    int seconds = ((milliseconds % 60000) / 1000).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/$image.jpg'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.skip_previous, size: 30),
                  onPressed: _skipBack,
                  label: Text(''),
                ),
                TextButton.icon(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 30,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      _pauseMusic();
                    } else {
                      _playMusic();
                    }
                  },
                  label: Text(''),
                ),
                SizedBox(width: 10),
                TextButton.icon(
                  icon: Icon(Icons.skip_next, size: 30),
                  onPressed: _skipNext,
                  label: Text(''),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTime(_currentPosition),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(width: 10),
                Container(
                  width: 300,
                  child: Slider(
                    min: 0.0,
                    max: _duration,
                    value: _currentPosition,
                    onChanged: (value) {
                      _seekTo(value);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  _formatTime(_duration),
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
