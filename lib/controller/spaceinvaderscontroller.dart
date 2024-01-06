import 'dart:async';
import 'dart:math';
import '../model/spaceinvadersmodel.dart';

class SpaceInvadersController {
  final SpaceInvadersModel model;
  Timer? gameTimer;
  Function? onGameWon;

  SpaceInvadersController({required this.model, this.onGameWon});

  void startGame() {
    gameTimer = Timer.periodic(
      const Duration(milliseconds: 100),
          (Timer timer) {
        moveAliens();
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
      // Optional: move aliens down one row here if desired
    }

    for (int i = 0; i < model.alien.length; i++) {
      if (model.alienDirection == 'right') {
        model.alien[i]++;
      } else {
        model.alien[i]--;
      }
    }
  }

  void updateGame() {
    model.updateAlienMissiles();
    model.updatePlayerMissile();
    model.checkGameWon();

    if (model.gameWon) {
      gameTimer?.cancel();
      onGameWon?.call();
    }
  }

  void fireAlienMissile() {
    if (model.alien.isNotEmpty) {
      int randomAlienIndex = Random().nextInt(model.alien.length);
      model.fireAlienMissile(model.alien[randomAlienIndex]);
    }
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
  }
}
