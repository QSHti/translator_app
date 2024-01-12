import 'package:flutter/material.dart';
import 'space_invaders_model.dart';

class SpaceInvadersPainter extends CustomPainter {
  final SpaceInvadersModel model;

  SpaceInvadersPainter(this.model);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    paint.color = Colors.blue;
    int spaceshipColumn = model.spaceship.first % 20;
    int spaceshipRow = model.spaceship.first ~/ 20;
    var spaceshipRect = Rect.fromLTWH(
      spaceshipColumn * size.width / 20,
      spaceshipRow * size.height / 35,
      size.width / 20,
      size.height / 35,
    );
    canvas.drawRect(spaceshipRect, paint);

    paint.color = Colors.green;
    for (var alienPos in model.alien) {
      var column = alienPos % 20;
      var row = alienPos ~/ 20;
      var alienRect = Rect.fromLTWH(
        column * size.width / 20,
        row * size.height / 35,
        size.width / 20,
        size.height / 35,
      );
      canvas.drawRect(alienRect, paint);
    }

    if (model.playerMissileShot != -1) {
      paint.color = Colors.red;
      var missileRect = Rect.fromCenter(
          center: Offset(model.playerMissileShot % 20 * 20.0, model.playerMissileShot / 20 * 20.0),
          width: 5.0,
          height: 20.0);
      canvas.drawRect(missileRect, paint);
    }

    paint.color = Colors.yellow;
    for (var missilePos in model.alienMissiles) {
      var missileRect = Rect.fromCenter(
          center: Offset(missilePos % 20 * 20.0, missilePos / 20 * 20.0),
          width: 5.0,
          height: 20.0);
      canvas.drawRect(missileRect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
