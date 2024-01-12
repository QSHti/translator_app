import 'package:flutter/material.dart';
import '../model/space_invaders_painter.dart';  // Ensure this path is correct
import '../controller/space_invaders_controller.dart';
import '../model/space_invaders_model.dart';

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
    controller = SpaceInvadersController(model: model, onGameWon: _showWinnerDialog, onGameOver: _showGameOverDialog);
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

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("The aliens have won! Better luck next time."),
          actions: <Widget>[
            TextButton(
              child: Text("Restart"),
              onPressed: () {
                Navigator.of(context).pop();
                controller.resetGame();
                controller.startGame();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Space Invaders')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: _handleDragUpdate,
              child: AnimatedBuilder(
                animation: model,
                builder: (context, _) {
                  return CustomPaint(
                    painter: SpaceInvadersPainter(model),
                    child: Container(),
                  );
                },
              ),
            ),
          ),
          _buildControlPanel(),
        ],
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // Add logic here to control the frequency and amount of spaceship movement
    if (details.delta.dx > 0) {
      controller.moveSpaceshipRight();
    } else if (details.delta.dx < 0) {
      controller.moveSpaceshipLeft();
    }
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
            },
            child: Text('Start'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.firePlayerMissile();
            },
            child: Text('Fire'),
          ),
        ],
      ),
    );
  }
}