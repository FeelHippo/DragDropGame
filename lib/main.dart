import 'package:flutter/material.dart';
import 'package:drag_drop/ui/ColorGame.dart';

void main() => runApp(DragDropApp());

class DragDropApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ColorGame(),
    );
  }
}