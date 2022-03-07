import 'package:flutter/material.dart';
import 'package:drag_drop/ui/Emoji.dart';
import 'package:drag_drop/ui/GenerateDragTarget.dart';
import 'dart:math';


class ColorGame extends StatefulWidget {
  const ColorGame({ Key? key }) : super(key: key);

  @override
  State<ColorGame> createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {
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
  updateGame(String emoji) {
    setState(() {
      score[emoji] = true;
    });
  }
  resetGame() {
    setState(() {
      score.clear();
      seed++;
    });
  }

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
          resetGame();
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
            children: choices
                .keys
                .map((emoji) => GenerateDragTarget(
                  emoji: emoji,
                  score: score,
                  choices: choices,
                  updateGame: updateGame,
                  resetGame: resetGame,
                )
            ).toList()..shuffle(Random(seed))
          )
        ],
      ),
    );
  }
}
