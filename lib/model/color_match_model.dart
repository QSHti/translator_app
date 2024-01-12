import 'package:flutter/material.dart';

class ColorMatchModel {
  String colorName;
  Color textColor;
  int score;

  ColorMatchModel({this.colorName = 'Red', this.textColor = Colors.red, this.score = 0});

  void resetGame() {
    colorName = 'Red';
    textColor = Colors.red;
    score = 0;
  }
}