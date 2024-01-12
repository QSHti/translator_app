class TicTacToeModel {
  List<String> board = List.generate(9, (index) => '');
  bool xTurn = true;

  void resetBoard() {
    board = List.generate(9, (index) => '');
    xTurn = true;
  }

  bool makeMove(int index) {
    if (board[index] == '') {
      board[index] = xTurn ? 'X' : 'O';
      xTurn = !xTurn;
      return true;
    }
    return false;
  }

  String checkWinner() {
    const winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];

    for (var combo in winningCombinations) {
      if (board[combo[0]] != '' &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]]) {
        return board[combo[0]];
      }
    }

    if (board.every((element) => element != '')) {
      return 'Draw';
    }

    return '';
  }
}
