import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(DragDropApp());

class DragDropApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'PressStart',
      ),
      home: ColorGame(),
    );
  }
}

class ColorGame extends StatefulWidget {
  createState() => ColorGameState();
}

class ColorGameState extends State<ColorGame> {
  final Map<String, bool> score = {};
  final Map choices = {
    '🌻': Colors.yellow,
    '🍎': Colors.red,
    '💩': Colors.brown,
    '🌼': Colors.white,
    '🍀': Colors.green,
    '🍊': Colors.orange,
  };

  int seed = 0;
  AudioCache _audioController = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score ${score.length} / 6'),
        backgroundColor: Colors.pink,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            score.clear();
            seed++;
          });
        },
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: choices.keys.map((emoji) {
              return Draggable<String>(
                data: emoji,
                child: Emoji(emoji: score[emoji] == true ? '🚀' : emoji),
                feedback:Emoji(emoji: emoji),
                childWhenDragging: Emoji(emoji: '👀'),
              );
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: choices.keys.map((emoji) => _buildDragTarget(emoji)).toList()..shuffle(Random(seed)),
          )
        ],
      ),
    );
  }
  
  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String?> incoming, List rejected) {
        return score[emoji] == true ? Container(
          color: Colors.white,
          child: Text('Bravo!'),
          alignment: Alignment.center,
          height: 80,
          width: 200,
        ) : Container(color: choices[emoji], height: 80, width: 200);
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
        });
        _audioController.play('success.mp4');
        if (score.length == choices.length) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('YOU WIN!'),
              content: const Text('Would you like to play again?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      score.clear();
                      seed++;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('YES YES YES!!!!!'),
                ),
              ],
            ),
          );
        };
      },
      onLeave: (data) {},
    );
  }
}

class Emoji extends StatelessWidget {
  Emoji({ Key? key, required this.emoji }) : super(key: key);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 80,
        padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 50),
        ),
      ),
    );
  }
}