import '../model/tictactoemodel.dart';

class TicTacToeController {
  final TicTacToeModel model = TicTacToeModel();

  // Handles a player's tap on the board
  void onTap(int index, Function(String) onWinnerFound, Function onInvalidMove) {
    bool moveMade = model.makeMove(index);
    if (!moveMade) {
      onInvalidMove();
      return;
    }

    String winner = model.checkWinner();
    if (winner != '') {
      onWinnerFound(winner);
    }
  }

  // Resets the game
  void resetGame() {
    model.resetBoard();
  }
}
