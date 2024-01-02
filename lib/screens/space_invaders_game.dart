import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SpaceInvadersGame extends StatefulWidget {
  @override
  _SpaceInvadersGameState createState() => _SpaceInvadersGameState();
}

class _SpaceInvadersGameState extends State<SpaceInvadersGame> {
  static const int spaceShipStartPos = numberOfSquares - 20;
  static const int numberOfSquares = 700;
  static bool alienGotHit = false;
  final myGoogleFont = GoogleFonts.orbitron(
      textStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30));

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

  static int alienStartPos = 30;
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

  void startGame() {
    Timer.periodic(
      const Duration(milliseconds: 700),
          (Timer timer) {
        alienMoves();
      },
    );
  }

  String direction = 'left';
  void alienMoves() {
    setState(() {
      if ((alien[0] - 1) % 20 == 0) {
        direction = 'right';
      } else if ((alien.last + 2) % 20 == 0) {
        direction = 'left';
      }

      if (direction == 'right') {
        for (int i = 0; i < alien.length; i++) {
          alien[i] += 1;
        }
      } else {
        for (int i = 0; i < alien.length; i++) {
          alien[i] -= 1;
        }
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!spaceship.contains(spaceship.first - 20)) {
        for (int i = 0; i < spaceship.length; i++) {
          spaceship[i] -= 1;
        }
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!spaceship.contains(spaceship.last + 20)) {
        for (int i = 0; i < spaceship.length; i++) {
          spaceship[i] += 1;
        }
      }
    });
  }

  int playerMissileShot = -1;
  void fireMissile() {
    playerMissileShot = spaceship.first;
    alienGotHit = false;
    Timer.periodic(
      const Duration(milliseconds: 50),
          (Timer timer) {
        updateMissilePosition();
        if (alienGotHit || playerMissileShot < 0) {
          timer.cancel();
        }
      },
    );
  }

  void updateMissilePosition() {
    setState(() {
      if (playerMissileShot >= 0) playerMissileShot -= 20;
      if (alien.contains(playerMissileShot)) {
        alien.remove(playerMissileShot);
        playerMissileShot = -1;
        alienGotHit = true;
        if (alien.isEmpty) {
          _showWinnerDialog();
        }
      }
    });
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have destroyed all the aliens!'),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      spaceship = [spaceShipStartPos];

      alien = List.generate(14, (index) => alienStartPos + index % 7 + (20 * (index ~/ 7)));

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  moveRight();
                } else if (details.delta.dx < 0) {
                  moveLeft();
                }
              },
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 20),
                itemBuilder: (BuildContext context, int index) {
                  if (playerMissileShot == index || spaceship.first == index) {
                    return PixelBox(color: Colors.red);
                  } else if (spaceship.contains(index)) {
                    return PixelBox(color: Colors.white);
                  } else if (alien.contains(index)) {
                    return PixelBox(color: Colors.green);
                  } else {
                    return PixelBox(color: Colors.black);
                  }
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: startGame,
                child: Text('Start', style: myGoogleFont),
              ),
              TextButton(
                onPressed: fireMissile,
                child: Text('Fire', style: myGoogleFont),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PixelBox extends StatelessWidget {
  final Color color;

  const PixelBox({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
