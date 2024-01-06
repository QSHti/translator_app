import 'package:flutter/material.dart';
import '../controller/tictactoecontroller.dart';

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToe> {
  final TicTacToeController controller = TicTacToeController();

  void _onTap(int index) {
    controller.onTap(index, _showWinnerDialog, _showInvalidMoveDialog);
    setState(() {});
  }

  void _showWinnerDialog(String winner) {
    final message = winner == 'Draw' ? 'The game is a draw!' : 'Player $winner won the game!';
    _showDialog('Game Over', message);
  }

  void _showInvalidMoveDialog() {
    _showDialog('Invalid Move', 'This spot is already taken. Please try another spot.');
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (title == 'Game Over') {
                  controller.resetGame();
                  setState(() {});
                }
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
      appBar: AppBar(title: Text('Tic Tac Toe')),
      body: GridView.builder(
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onTap(index),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  controller.model.board[index],
                  style: TextStyle(fontSize: 72, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}