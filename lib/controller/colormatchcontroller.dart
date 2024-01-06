import 'dart:math';
import '../model/colormatchmodel.dart';
import 'package:flutter/material.dart';

class ColorMatchController {
  final ColorMatchModel model;
  final List<String> colorNames = ['Red', 'Green', 'Blue', 'Yellow'];
  final Map<String, Color> colorMap = {
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Yellow': Colors.yellow,
  };

  ColorMatchController(this.model);

  void nextColor() {
    Random random = Random();
    int nameIndex = random.nextInt(colorNames.length);
    int colorIndex = random.nextInt(colorMap.length);

    model.colorName = colorNames[nameIndex];
    model.textColor = colorMap.values.elementAt(colorIndex);
  }

  bool checkMatch() {
    return colorMap[model.colorName] == model.textColor;
  }

  void updateScore(bool correctAnswer) {
    if (correctAnswer) {
      model.score++;
    } else {
      model.score--;
    }
  }

  void resetGame() {
    model.resetGame();
    nextColor(); // Initialize the first color for the new game
  }
}
