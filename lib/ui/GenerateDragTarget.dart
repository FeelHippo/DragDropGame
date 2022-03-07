import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class GenerateDragTarget extends StatelessWidget {
  GenerateDragTarget({
    Key? key, required this.emoji,
    required this.score,
    required this.choices,
    required this.updateGame,
    required this.resetGame,
  }) : super(key: key);

  final String emoji;
  final Map<String, bool> score;
  final Map choices;
  final Function(String) updateGame;
  final Function() resetGame;
  final AudioCache _audioController = AudioCache();

  @override
  Widget build(BuildContext context) {
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
        updateGame(emoji);
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
                    resetGame();
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