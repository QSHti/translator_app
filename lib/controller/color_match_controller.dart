import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/color_match_model.dart';

class ColorMatchController {
  final ColorMatchModel model;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  void resetGame() => model.resetGame();

  Future<void> gameOver(VoidCallback showGameOverDialog) async {
    await saveHighScore(model.score);
    showGameOverDialog();
    resetGame();
  }

  void updateScore(bool match, VoidCallback showGameOverDialog) {
    if (match == checkMatch()) {
      model.score++;
      nextColor();
    } else {
      saveHighScore(model.score).then((_) {
        showGameOverDialog();
      });
    }
  }

  Future<void> saveHighScore(int score) async {
    User? user = _auth.currentUser;
    var highScoreData = {
      'score': score,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': user?.uid ?? 'anonymous',
      'username': user?.displayName ?? 'Anonymous',
    };
    await firestore.collection('highscores')
        .add(highScoreData)
        .catchError((error) => print("Failed to add high score: $error"));
  }

  Stream<QuerySnapshot> getTopHighScores() {
    return firestore
        .collection('highscores')
        .orderBy('score', descending: true)
        .limit(3)
        .snapshots();
  }
}
