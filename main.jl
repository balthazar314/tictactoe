ENV["JULIA_DEBUG"] = "all"

# tell julia to look for packages in the local directory
push!(LOAD_PATH, @__DIR__)

# this package is defined in TicTacToe.jl 
# contains types and utility functions for playing TicTacToe
import TicTacToe
import TicTacToe: Winner, Draw, Inconclusive
# package defined in DrawUtils.jl
# contains utilities for drawing the game board
import DrawUtils

# this file contains the AI
# I might make it a package
include("TreeWalker.jl")

# this file contains an AI that tries to cheet
#include("Cheeter.jl")

# human interface in case you want to play against the AI
include("HumanPlayer.jl")

include("RandomPlayer.jl")

# players 1 and 2 are tuples of descision functions and tokens (either X or O)
function  main(player1, player2, board = TicTacToe.empty_board())

	# use this so players can't edit the board freely
	# stops cheeters
	backup_board = copy(board)
	
	# clear the screen and draw the starting board
	# DrawUtils.clear_screen()
	# DrawUtils.draw_board(board)
	
	# while the game is not over
	while TicTacToe.winner(board) == Inconclusive()
		
		# ask a player which square they would like to put their token into
		# whyt function gets called depends on what type the player oject in player1 is
		# for more information check out 'HumanPlayer.jl'	
		# last_move = move(player1..., board)

		# all the logic happens in a function that take the current game peice and the current board
		current_player, token = player1
		last_move = current_player(token, board)

		# before commiting the move to the board, check if it's legal
		if TicTacToe.is_legal_move(board, last_move)
			# put  the players token in the square they requested
			backup_board[last_move] = player1[2]
			
			# make a backup of the board (this should copy without allocating a board each time)
			board[:] .= backup_board[:]
			
			# put player one at the back of the line and move player two to the front
			(player1, player2) = (player2, player1)
		else
			# if a player tried to make an illegal move, flip the tabel and quit the game
			println("illegal move")
			println(" player tried to put an $(player1[2]) in space $(last_move) which already had a $(board[last_move])")
			break
		end
		# clear the screen and draw the updated board
		# DrawUtils.clear_screen()
		# DrawUtils.draw_board(board)
	end
	
	# check the result of the game
	result = TicTacToe.winner(board)
	
	DrawUtils.clear_screen()
	DrawUtils.draw_board(board)

	if result isa Draw
		println("Draw")
	elseif result isa Winner
		println( "$(result.winner) has won!")
	else
		println("something went wrong")
	end	
end

@time main( (TreeWalker, X), (TreeWalker, O))
