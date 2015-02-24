class Board
  attr_reader :board

  def initialize
    generate_board

  end

  def in_check?(color)

  end

  def generate_board
    @board = Array.new(8) { Array.new(8) { nil } }



  end



end

board = Board.new

p board.board
