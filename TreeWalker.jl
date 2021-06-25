using TicTacToe


function TreeWalker(me::PlayerToken, board)

    best_move, best_outcome =  width_first_search(board, me) 
    #@debug "playing $best_move, going for a $best_outcome"
    
    return best_move
end

function width_first_search(board, me)

    # remember one draw and one loss in case we can't find any winning moves
    # note these are invalid moves
    draw = 0
    loss = 0

    # algorithem takes two passes, initially saving inconclusive moves here 
    for_later = Int[]
    sizehint!(for_later, 9)
    
    opponent = PlayerToken(!me.isX)
    
    # populate with all legal moves
    # menwhile keeping an eye out for any wins
    for move in legal_moves(board)
        board[move] = me
        result = winner(board)
        board[move] = empty_square
        
        # if any options are wins break out early
        if  result == Winner(me) 
            return (move, result)
        # save a draw as a backup plan
        elseif result == Draw() 
            draw=move
        # save a loss so we can loose with honor
        elseif result == Winner(opponent) 
            loss=move
        # don't calculate these unless you have to
        elseif result == Inconclusive()
            push!(for_later, move)
        else
            error("unrecognised result $result")
        end

    end

    # since there aren't any short term wins at this point, it is time to start
    # looking a few steps ahead
    # this basically means evaluating all the Inconclusive elements by looking at what our opponent would do
    # meanwhile also looking for any wins (notice a pattern?)
    for move in for_later
        board[move] = me
        result = width_first_search(board, opponent) |> last # here `last` means the econd element of the tuple
                                                            # i.e. the result, not the opponents move
        board[move] = empty_square
        
        # if any options are wins break out early
         if  result == Winner(me) 
            return (move, result)
        # options[move] = result
        # save a draw as a backup plan
        elseif result == Draw() 
            draw=move
        # save a loss so we can loose with honor
        elseif result == Winner(opponent) 
            loss=move
        elseif result == Inconclusive()
            error("unexpected inconclusive result")
        else
            error("unrecognised result $result")
        end
    end

    # at this point there is no hope of winning, so if we have a draw, we return that instead
    if draw != 0
        return draw, Draw()
    elseif loss != 0 
        return loss, Winner(opponent)
    else
        error("no win's, losses, or draws recorded")
    end
end
