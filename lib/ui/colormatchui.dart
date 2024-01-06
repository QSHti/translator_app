import 'package:flutter/material.dart';
import '../controller/colormatchcontroller.dart'; // Adjust this import path as needed
import '../model/colormatchmodel.dart'; // Adjust this import path as needed

class ColorMatchGame extends StatefulWidget {
  @override
  _ColorMatchGameState createState() => _ColorMatchGameState();
}

class _ColorMatchGameState extends State<ColorMatchGame> {
  late final ColorMatchController controller;
  late final ColorMatchModel model;

  @override
  void initState() {
    super.initState();
    model = ColorMatchModel();
    controller = ColorMatchController(model);
    controller.nextColor(); // Initialize the first color for the game
  }

  void _handleAnswer(bool match) {
    bool isCorrect = controller.checkMatch() == match;
    controller.updateScore(isCorrect);

    if (isCorrect) {
      controller.nextColor();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Match Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              model.colorName,
              style: TextStyle(color: model.textColor, fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Score: ${model.score}', style: TextStyle(fontSize: 24)),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _handleAnswer(true),
                  child: Text('Match', style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton(
                  onPressed: () => _handleAnswer(false),
                  child: Text('No Match', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
