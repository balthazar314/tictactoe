push!(LOAD_PATH, @__DIR__)

using TicTacToe

include("TreeWalker.jl")

using Traceur

function next_board!(board = empty_board())
    all(board .== Ref(O)) && return nothing
    increments = Dict(empty_square=>(X, false), X=> (O, false), O => (empty_square, true))
    carry=false
    for (index, item) in pairs(IndexLinear(), board)
        new_value, carry = increments[item]
        board[index] = new_value
        carry || return board
    end
    
end

function test_walker()
    board = empty_board()
    Xboard = copy(board)
    Oboard = copy(board)

    data = [] 
    sizehint!(data, 19683)
    i=0
    #open("test_data.serialized", "w") do data_file
        
    while board != nothing
        # make a copy of the board in case it's modified
        Xboard[:] .= board[:]
        Oboard[:] .= board[:]

        x_time =  @elapsed pick_move(Xboard, X)
        o_time = @elapsed pick_move(Oboard, O)
        
        #Serialization.serialize(data_file, board=>(x_time, o_time))
        push!(data, copy(board)=> (x_time, o_time))
        board = next_board!(board)
        i > 20000 && error("over run iteration limit")
        i +=1 
    end
    return data
end

function f(x)
    s=0
    for n in 1:10
        s *= x
    end
    return s
end

width_first_search(empty_board(), X)
@trace width_first_search(empty_board(), X)
