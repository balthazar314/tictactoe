module TicTacToe
    # export types
    export AbstractPlayer, SquareValue, EmptySquare, PlayerToken
    export Winner, Draw, Inconclusive, GameState
    
    # export special values
    export X, O, empty_square
    
    # export utility functions
    #export won, is_draw, 
    export winner, is_legal_move, legal_moves, empty_board

    # export functions overloaded from base
    export show

    # define values that fill the tic tac toe board
    abstract type SquareValue end

    # describes a square that is empty
    struct EmptySquare <: SquareValue end
    
    # describes either an X or an O
    struct PlayerToken <: SquareValue
        isX::Bool
    end

    empty_board((w,h) = (3,3)) = Matrix{SquareValue}(fill(empty_square, (w,h)))

    const X, O = PlayerToken.([true, false])
    const empty_square = EmptySquare()


    Base.show(io::IO, ::EmptySquare) = print(io," ")
    Base.show(io::IO, plr::PlayerToken) = print(io, plr.isX ? 'X' : 'O') 
    
    # describes the state of the game
    abstract type GameState end
    
    # end state of the game where someone won
    struct Winner  <: GameState
        winner::PlayerToken
    end
    
    # end state of the game where no one won
    struct Draw <: GameState end
    
    # game is stil going, no one won yet
    struct Inconclusive <: GameState end
    

    # returns a `Winner` object containing the identity of the winner  ff someone won, 
    # a `Draw()` if the game was a draw
    # and `Inconclusive()`if the game isn't over yet
    function winner(board)
        won(board, X) && return Winner(X)
        won(board, O) && return Winner(O)
        is_draw(board) && return Draw()
        return Inconclusive()
    end

    # function to check who won
    won(board, c::PlayerToken) = all(board[[1,5,9]].==Ref(c)) || # check the diagonal
                                all(board[[7,5,3]].==Ref(c) ) || # check the opposite diagonal
                                any(1:3) do i;          # check the i'th row and collumn
                                    all(board[i,:] .== Ref(c)) || all(board[:,i].==Ref(c)) 
                                end

    # function to check if there was a draw
    is_draw(board) = all(square!=empty_square for square in board)

    is_legal_move(board, move) = move in LinearIndices(board) && board[move] == empty_square

    legal_moves(board) = Set(move for move in LinearIndices(board) if board[move] == empty_square)

end
