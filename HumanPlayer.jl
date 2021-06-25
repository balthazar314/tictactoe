
# the 'AI's here are actually just functions that take what token they are and the current game board
# they return a number from 1 to 9 that represents the square on the game board that they want to fill in with their token
# the squares are numbered like so
#=
	7|8|9
	-----
	4|5|6
	-----
	1|2|3

	I did it like this because this maps nicely to the numpad on my keyboard
=#
# all the HumanPlayer function does is ask you which cell you want to fill in
function HumanPlayer(::PlayerToken, board)
	while true
		println("Select a square using the number keys.\n legal moves are $(legal_moves(board))")
	
		input = parse(Int, readline())
		if input in legal_moves(board)
			return input
		else
			print("that is not a legal move")
		end
	end
end