import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/color_match_controller.dart';
import '../model/color_match_model.dart';

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
    controller.nextColor();
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Your score: ${model.score}'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    ).then((_) {
      controller.resetGame();
      controller.nextColor();
      setState(() {});
    });
  }



  void _handleAnswer(bool match) {
    controller.updateScore(match, _showGameOverDialog);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Match Game'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                _buildGameButton('Match', true),
                _buildGameButton('No Match', false),
              ],
            ),
            SizedBox(height: 20),
            Expanded(child: _buildHighScoreList()),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton(String label, bool match) {
    return ElevatedButton(
      onPressed: () => _handleAnswer(match),
      child: Text(label, style: TextStyle(fontSize: 20)),
      style: ElevatedButton.styleFrom(
        primary: match ? Colors.green : Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildHighScoreList() {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.getTopHighScores(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['username'] ?? 'Anonymous'),
              trailing: Text(data['score'].toString()),
            );
          }).toList(),
        );
      },
    );
  }
}
