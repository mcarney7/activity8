import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // For sound effects
import 'dart:async'; // For Timer
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
  List<double> _floatingTops = [];
  List<double> _floatingLefts = [];
  Timer? _floatingTimer;

  @override
  void initState() {
    super.initState();

    // Start looping spooky background music
    _audioPlayer.setReleaseMode(ReleaseMode.LOOP); // Set the release mode to loop
    _audioPlayer.play('assets/sound1.mp3', isLocal: true);

    _correctIndex = _random.nextInt(6); // Randomize the "correct" item

    // Initialize random positions for all floating items
    for (int i = 0; i < 6; i++) {
      _floatingTops.add(_random.nextDouble() * 400);
      _floatingLefts.add(_random.nextDouble() * 300);
    }

    // Start a timer to update the position of all floating items every 2 seconds
    _floatingTimer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      setState(() {
        for (int i = 0; i < 6; i++) {
          _floatingTops[i] = _random.nextDouble() * 400;
          _floatingLefts[i] = _random.nextDouble() * 300;
        }
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _floatingTimer?.cancel(); // Cancel the timer when disposing
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
      // All items float around, but only one is the correct item
      items.add(_buildFloatingItem(i));
    }
    return Stack(children: items);
  }

  Widget _buildFloatingItem(int index) {
    // All floating items, including the correct one
    return AnimatedPositioned(
      duration: Duration(seconds: 2), // Controls the animation speed
      top: _floatingTops[index],
      left: _floatingLefts[index],
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
