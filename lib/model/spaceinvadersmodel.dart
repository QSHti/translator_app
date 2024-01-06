import 'package:flutter/material.dart';

class SpaceInvadersModel {
  static const int spaceShipStartPos = 550;
  static const int numberOfSquares = 700;
  static int alienStartPos = 30;

  List<int> spaceship = [spaceShipStartPos];
  List<int> barriers = [
    numberOfSquares - 160 + 2,
    numberOfSquares - 160 + 3,
    numberOfSquares - 160 + 4,
    numberOfSquares - 160 + 5,
    numberOfSquares - 160 + 8,
    numberOfSquares - 160 + 9,
    numberOfSquares - 160 + 10,
    numberOfSquares - 160 + 11,
    numberOfSquares - 160 + 14,
    numberOfSquares - 160 + 15,
    numberOfSquares - 160 + 16,
    numberOfSquares - 160 + 17,
    numberOfSquares - 140 + 2,
    numberOfSquares - 140 + 3,
    numberOfSquares - 140 + 4,
    numberOfSquares - 140 + 5,
    numberOfSquares - 140 + 8,
    numberOfSquares - 140 + 9,
    numberOfSquares - 140 + 10,
    numberOfSquares - 140 + 11,
    numberOfSquares - 140 + 14,
    numberOfSquares - 140 + 15,
    numberOfSquares - 140 + 16,
    numberOfSquares - 140 + 17,
  ];

  List<int> alien = [
    alienStartPos,
    alienStartPos + 1,
    alienStartPos + 2,
    alienStartPos + 3,
    alienStartPos + 4,
    alienStartPos + 5,
    alienStartPos + 6,
    alienStartPos + 20,
    alienStartPos + 21,
    alienStartPos + 22,
    alienStartPos + 23,
    alienStartPos + 24,
    alienStartPos + 25,
    alienStartPos + 26
  ];

  List<int> alienMissiles = [];
  int playerMissileShot = -1;
  bool alienGotHit = false;
  String alienDirection = 'left';
  bool gameWon = false;
  int score = 0;

  SpaceInvadersModel() {
    reset();
  }

  // This method is used to restart the game without creating a new model instance.
  void reset() {
    spaceship = [spaceShipStartPos];
    alien = [
      alienStartPos,
      alienStartPos + 1,
      alienStartPos + 2,
      alienStartPos + 3,
      alienStartPos + 4,
      alienStartPos + 5,
      alienStartPos + 6,
      alienStartPos + 20,
      alienStartPos + 21,
      alienStartPos + 22,
      alienStartPos + 23,
      alienStartPos + 24,
      alienStartPos + 25,
      alienStartPos + 26
    ];
    alienMissiles.clear();
    playerMissileShot = -1;
    alienGotHit = false;
    alienDirection = 'left';
    gameWon = false;
    score = 0;
  }

  void fireAlienMissile(int alienPosition) {
    alienMissiles.add(alienPosition + 20); // Assuming a grid of 20 columns
  }

  void updateAlienMissiles() {
    for (int i = 0; i < alienMissiles.length; i++) {
      alienMissiles[i] += 20; // Move the missile down the grid
    }
    alienMissiles.removeWhere((pos) => pos >= numberOfSquares); // Remove missiles that are off the grid
  }

  void moveSpaceshipLeft() {
    if (spaceship.first % 20 != 0) {
      spaceship[0]--;
    }
  }

  void moveSpaceshipRight() {
    if (spaceship.first % 20 != 19) {
      spaceship[0]++;
    }
  }

  void firePlayerMissile() {
    if (playerMissileShot == -1) { // Can fire if there is no missile already in flight
      playerMissileShot = spaceship.first - 20;
    }
  }

  void updatePlayerMissile() {
    if (playerMissileShot >= 0) {
      playerMissileShot -= 20;
      if (playerMissileShot < 0 || alien.contains(playerMissileShot)) {
        if (alien.contains(playerMissileShot)) {
          alien.remove(playerMissileShot);
          score += 10; // Increment score for hitting an alien
        }
        playerMissileShot = -1;
      }
    }
  }

  void checkGameWon() {
    gameWon = alien.isEmpty;
  }

}
