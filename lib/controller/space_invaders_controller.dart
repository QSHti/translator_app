import 'dart:async';
import 'dart:math';
import '../model/space_invaders_model.dart';

class SpaceInvadersController {
  final SpaceInvadersModel model;
  Timer? gameTimer;
  Function? onGameWon;
  Function? onGameOver;
  final int alienFireRate = 5;

  SpaceInvadersController({required this.model, this.onGameWon, this.onGameOver});

  void startGame() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(
      const Duration(milliseconds: 100),
          (Timer timer) {
        moveAliens();
        maybeFireAlienMissile();
        updateGame();
      },
    );
  }

  void moveAliens() {
    if (model.alien.isEmpty) return;

    bool changeDirection = false;
    for (int alienIndex in model.alien) {
      if ((alienIndex % 20 == 19 && model.alienDirection == 'right') ||
          (alienIndex % 20 == 0 && model.alienDirection == 'left')) {
        changeDirection = true;
        break;
      }
    }

    if (changeDirection) {
      model.alienDirection = model.alienDirection == 'left' ? 'right' : 'left';
    }

    for (int i = 0; i < model.alien.length; i++) {
      if (model.alienDirection == 'right') {
        model.alien[i]++;
      } else {
        model.alien[i]--;
      }
    }
  }

  void maybeFireAlienMissile() {
    if (model.alien.isNotEmpty && Random().nextInt(100) < alienFireRate) {
      int shootingAlienIndex = Random().nextInt(model.alien.length);
      model.fireAlienMissile(model.alien[shootingAlienIndex]);
    }
  }

  void updateGame() {
    model.updateAlienMissiles();
    model.updatePlayerMissile();
    checkCollisions();
    model.checkGameWon();

    if (model.gameWon) {
      gameTimer?.cancel();
      onGameWon?.call();
    } else if (isGameOver()) {
      gameTimer?.cancel();
      onGameOver?.call();
    }
  }

  bool isGameOver() {
    for (int missile in model.alienMissiles) {
      if (model.spaceship.contains(missile)) {
        return true;
      }
    }
    return false;
  }

  void checkCollisions() {
    if (model.playerMissileShot != -1) {
      if (model.alien.contains(model.playerMissileShot)) {
        model.alien.remove(model.playerMissileShot);
        model.playerMissileShot = -1;
        model.score += 10;
      } else if (model.playerMissileShot < 20) {
        model.playerMissileShot = -1;
      }
    }

    for (int missile in model.alienMissiles) {
      if (isMissileHittingSpaceship(missile)) {
        gameTimer?.cancel();
        onGameOver?.call();
        break;
      }
    }
    model.alienMissiles.removeWhere((missile) => missile >= SpaceInvadersModel.numberOfSquares);
  }

  bool isMissileHittingSpaceship(int missile) {
    int missileRow = missile ~/ 20;
    int missileColumn = missile % 20;
    int spaceshipRow = model.spaceship.first ~/ 20;
    int spaceshipColumn = model.spaceship.first % 20;

    return missileRow == spaceshipRow &&
        missileColumn >= spaceshipColumn - 1 &&
        missileColumn <= spaceshipColumn + 1;
  }

  void moveSpaceshipLeft() {
    model.moveSpaceshipLeft();
  }

  void moveSpaceshipRight() {
    model.moveSpaceshipRight();
  }

  void firePlayerMissile() {
    model.firePlayerMissile();
  }

  void resetGame() {
    gameTimer?.cancel();
    model.reset();
    startGame();
  }
}
