using TicTacToe

RandomPlayer(::PlayerToken ,board) = rand(legal_moves(board))
