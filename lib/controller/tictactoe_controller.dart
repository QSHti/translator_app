import '../model/tictactoe_model.dart';

class TicTacToeController {
  final TicTacToeModel model = TicTacToeModel();

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

  void resetGame() {
    model.resetBoard();
  }
}
