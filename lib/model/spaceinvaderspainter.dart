import 'package:flutter/material.dart';
import 'spaceinvadersmodel.dart';

class SpaceInvadersPainter extends CustomPainter {
  final SpaceInvadersModel model;

  SpaceInvadersPainter(this.model);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw the spaceship
    paint.color = Colors.black; // Make sure the color contrasts with the background
    int spaceshipColumn = model.spaceship.first % 20;
    int spaceshipRow = model.spaceship.first ~/ 20;
    var spaceshipRect = Rect.fromLTWH(
      spaceshipColumn * size.width / 20, // Calculate the X position
      spaceshipRow * size.height / 35, // Calculate the Y position, assuming 35 rows
      size.width / 20, // Width of the spaceship
      size.height / 35, // Height of the spaceship
    );
    canvas.drawRect(spaceshipRect, paint);

    // Draw the aliens
    paint.color = Colors.green;
    for (var alienPos in model.alien) {
      var alienRect = Rect.fromCenter(
          center: Offset(alienPos % 20 * 20.0, alienPos / 20 * 20.0),
          width: 18.0,
          height: 18.0);
      canvas.drawRect(alienRect, paint);
    }

    // Draw the player's missile
    if (model.playerMissileShot != -1) {
      paint.color = Colors.red;
      var missileRect = Rect.fromCenter(
          center: Offset(model.playerMissileShot % 20 * 20.0, model.playerMissileShot / 20 * 20.0),
          width: 5.0,
          height: 20.0);
      canvas.drawRect(missileRect, paint);
    }

    // Draw the aliens' missiles
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