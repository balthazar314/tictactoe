using TicTacToe

struct Cheeter <: AbstractPlayer
end

function move(::Cheeter, token::PlayerToken, board)
    fake_move = first(legal_moves(board))
    
    # the board is backed up so this no longer works
    # board[1:3] .=  token
    
    # this doesn't work because the code is in another module 
    #TicTacToe.empty_square = token
    return fake_move
end