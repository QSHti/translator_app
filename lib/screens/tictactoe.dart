import 'package:flutter/material.dart';

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToe> {
  List<String> board = List.generate(9, (index) => '');
  bool xTurn = true;

  void _onTap(int index) {
    if (board[index] == '') {
      setState(() {
        board[index] = xTurn ? 'X' : 'O';
        xTurn = !xTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    const winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
      [0, 4, 8], [2, 4, 6]             // diagonals
    ];

    for (var combo in winningCombinations) {
      if (board[combo[0]] != '' &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]]) {
        // Winner!
        _showWinnerDialog(board[combo[0]]);
        return;
      }
    }

    // Check for draw
    if (board.every((element) => element != '')) {
      _showDrawDialog();
    }
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Winner!'),
          content: Text('Player $winner won the game!'),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetBoard();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Draw!'),
          content: Text('The game is a draw!'),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetBoard();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetBoard() {
    setState(() {
      board = List.generate(9, (index) => '');
      xTurn = true;
    });
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
              ),
              child: Center(
                child: Text(
                  board[index],
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}