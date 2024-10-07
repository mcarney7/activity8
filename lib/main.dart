import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // For sound effects
import 'dart:math'; // For random position

void main() {
  runApp(HalloweenGame());
}

class HalloweenGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tricky Halloween Game',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Creepster', // Add a spooky font!
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isGameOver = false;
  final Random _random = Random();
  int _correctIndex = 0;
  
  @override
  void initState() {
    super.initState();
    // Start spooky background music
    _audioPlayer.play('assets/sound1.mp3', isLocal: true);
    _correctIndex = _random.nextInt(6); // Randomize the "correct" item
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleItemClick(int index) {
    if (index == _correctIndex) {
      // Play a "You found it!" sound and show success message
      _audioPlayer.play('assets/sound2.mp3', isLocal: true);
      setState(() {
        _isGameOver = true;
      });
    } else {
      // Play a spooky sound for the trap
      _audioPlayer.play('assets/sound3.mp3', isLocal: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spooky Halloween Hunt!'),
      ),
      body: Stack(
        children: [
          // Spooky background
          Positioned.fill(
            child: Image.asset('assets/image1.png', fit: BoxFit.cover),
          ),
          _isGameOver
              ? Center(child: Text("You Found It!", style: TextStyle(fontSize: 40, color: Colors.orange)))
              : _buildGameItems(),
        ],
      ),
    );
  }

  Widget _buildGameItems() {
    List<Widget> items = [];
    for (int i = 0; i < 6; i++) {
      items.add(_buildGameItem(i));
    }
    return Stack(children: items);
  }

  Widget _buildGameItem(int index) {
    // Random positions
    double top = _random.nextDouble() * 400;
    double left = _random.nextDouble() * 300;

    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () => _handleItemClick(index),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          child: Image.asset(
            index == _correctIndex ? 'assets/image2.png' : 'assets/spooky_character_$index.png',
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
