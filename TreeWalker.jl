using TicTacToe


function TreeWalker(me::PlayerToken, board)
    #println("thinking...")

    best_move, best_outcome =  width_first_search(board, me) #pick_move(board, me)
    #@debug "playing $best_move, going for a $best_outcome"
    
    return best_move
end

function width_first_search(board, me)
    
    # all options are heald in a dict of moves to results
    # it is initially empty
    # options = Dict()
    
    #note this is an invalid move
    draw = 0
    loss = 0
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
        # options[move] = result
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

    # since there aren't any short term wins at this point, it is time to start looking a few steps ahead
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
        # don't calculate these unless you have to
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
        error("no win's losses, or draws recorded")
    end
    # for (move, result) in options
    #     if result == Inconclusive()
    #         opponent = PlayerToken(!me.isX)
    #         board[move] = me
    #         options[move] =  width_first_search(board, opponent) |> last # here `last` means the econd element of the tuple
    #                                                                      # i.e. the result, not the opponents move
    #         board[move] = empty_square
            
    #         # if any options are wins break out early
    #         options[move] == Winner(me) && return (move, options[move])
    #     end
    # end
    # at this point all the hard work is done
    # we need to reutrn something, preferentially a draw
    # so sort the moves so that any draws that exist will be on top
    # then take the first one    
    # return sort(collect(options), by=last, lt=(a,b)-> b==Draw(), rev=true) |> first 

end

# any outcome is better than no outcome 
# this rule doesn't really make sence but it's neccessary
better_outcome(me, ::Inconclusive, ::GameState) = false
better_outcome(me, ::Union{Draw, Winner}, ::Inconclusive ) =  true

# a win is better than a draw (or a potential loss) if I'm the one winning
better_outcome(me, a::Winner, b::Union{Draw, Winner}) = a.winner == me

# a draw is better than my opponent winning
better_outcome(me, a::Draw, b::Winner) =  b.winner != me

# strictly speaking, a draw isn't better than a draw
# but this rule could be different and it wouldn't matter
better_outcome(me, a::Draw, b::Draw) = false 



function pick_move(board, me)
    
    # the best move encountered so far
    best_move = nothing

    # the best oiutcome encountered so far
    best_outcome = Inconclusive()
    
    for move in legal_moves(board)
        # try a move
        board[move] = me
        
        # see the result
        outcome = winner(board)    
        
        # if the result isn't immediatly obvious, try thinking one step ahead
        # if our opponent thinks like we do, see what move they will choose if we pick this move
        if outcome == Inconclusive()
            opponent  = PlayerToken(!me.isX)
            opponents_move, outcome = pick_move(board, opponent)
        end
        
        # can do clean up now because board isn't referenced
        # reset the game board before trying another move
        board[move] = empty_square 

        # if the final outcome of this move is better than our previous best
        # go with it instead       
        if better_outcome(me, outcome, best_outcome)
            best_outcome = outcome
            best_move = move
        end

        # this optomization cuts the time taken to make the first move in half
        # probably because you don't spend time cheking other branches
        if best_outcome == Winner(me)
            break
        end    
        
    end
    
    return best_move, best_outcome
end

