require_relative './chess_board.rb'
require_relative './piece.rb'

class Game
  def initialize
    @board = Board.new(true)
    @white_player = HumanPlayer.new("white")
    @black_player = HumanPlayer.new("black")
    @color_turn = "white"
    @player = @white_player
  end

  def play

    until game_over?
  begin
      @board.render
      start_pos, end_pos = @player.play_turn
      check_right_player?(start_pos)
      @board.move(start_pos, end_pos)
      color_toggle
  rescue => e
    puts "Invalid move: #{e}"
    retry
    end
  end
end

  def check_right_player?(pos)
    raise "Wrong piece!" unless @board[pos].color == @color_turn
  end

  def game_over?
    @board.checkmate?(@color_turn)
  end

  def color_toggle
    @color_turn = (@color_turn == "white" ? "black" : "white")
    @player = (@color_turn == "white" ? @white_player : @black_player)
  end


end



class HumanPlayer
  def initialize(color)
    @color = color
  end

  def play_turn
    puts "#{@color.capitalize}, please enter your move: 'eg. 0,0-2,3'"

    input = gets.chomp
    input.split(//)
    parse_input(input)
  end

  def parse_input(input)
    start_pos = [input[0].to_i, input[2].to_i]
    end_pos = [input[4].to_i, input[6].to_i]
    [start_pos, end_pos]
  end

end

game = Game.new
game.play
