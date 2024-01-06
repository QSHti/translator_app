import 'package:flutter/material.dart';
import '../model/spaceinvaderspainter.dart';  // Ensure this path is correct
import '../controller/spaceinvaderscontroller.dart';
import '../model/spaceinvadersmodel.dart';

class SpaceInvadersGame extends StatefulWidget {
  @override
  _SpaceInvadersGameState createState() => _SpaceInvadersGameState();
}

class _SpaceInvadersGameState extends State<SpaceInvadersGame> {
  late final SpaceInvadersController controller;
  late final SpaceInvadersModel model;


  @override
  void initState() {
    super.initState();
    model = SpaceInvadersModel();
    controller = SpaceInvadersController(model: model, onGameWon: _showWinnerDialog);
    controller.startGame();
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You have destroyed all the aliens!"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Space Invaders'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  controller.moveSpaceshipRight();
                } else if (details.delta.dx < 0) {
                  controller.moveSpaceshipLeft();
                }
                _update();
              },
              child: CustomPaint(
                painter: SpaceInvadersPainter(model),
                child: Container(),
              ),
            ),
          ),
          _buildControlPanel(),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              controller.resetGame();
              controller.startGame();
              _update();
            },
            child: Text('Start'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.firePlayerMissile();
              _update();
            },
            child: Text('Fire'),
          ),
        ],
      ),
    );
  }
}