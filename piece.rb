

class Piece
  DIAGONALS =  [[-1,-1], [1,-1], [-1,1], [1,1]]
  LATERALS = [[0,1], [1,0], [-1,0], [0,-1]]

  attr_reader :symbol, :pos

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @moved = false
  end

  def get_valid_moves
    #Return an array of positions
    @valid_moves = operation

  end

  def on_board?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end
end

class SlidingPiece < Piece

  def moves
    moves = []

    move_dirs.each do |dir|
      curr_pos = @pos
      while on_board?(curr_pos)
        x,y = curr_pos
        new_pos = [dir[0] + x, dir[1] + y]
        moves << new_pos if on_board?(new_pos)
        curr_pos = new_pos
      end
    end

    moves
  end
end

class SteppingPiece < Piece
  def moves
    moves = []
    move_dirs.each do |dir|
      curr_pos = @pos
      x,y = curr_pos
      new_pos = [dir[0] + x, dir[1] + y]
      moves << new_pos if on_board?(new_pos)
    end

    moves
  end

end

class Knight < SteppingPiece

  def initialize(color, pos, board)
    super(color, pos, board)
    @symbol = (color == "white" ? "\u{2658}" : "\u{265E}")
  end

  def move_dirs
    [[-2, -1], [-2,  1], [-1, -2], [-1,  2],
     [ 1, -2], [ 1,  2], [ 2, -1], [ 2,  1]]
  end
end

class King < SteppingPiece

  def initialize(color, pos, board)
    super(color, pos, board)
    @symbol = (color == "white" ? "\u{2654}" : "\u{265A}")
  end

  def move_dirs
    DIAGONALS + LATERALS
  end
end

class Rook < SlidingPiece
  def initialize(color, pos, board)
    super(color, pos, board)
    @symbol = (color == "white" ? "\u{2656}" : "\u{265C}")
  end

  def move_dirs
    LATERALS
  end


end

class Bishop < SlidingPiece
  def initialize(color, pos, board)
    super(color, pos, board)
    @symbol = (color == "white" ? "\u{2657}" : "\u{265D}")
  end

  def move_dirs
    DIAGONALS
  end

end

class Queen < SlidingPiece
  def initialize(color, pos, board)
    super(color, pos, board)
    @symbol = (color == "white" ? "\u{2655}" : "\u{265B}")
  end

  def move_dirs
    DIAGONALS + LATERALS
  end

end

class Pawn < Piece
  def initialize(color, pos, board)
    super(color, pos, board)
    @symbol = (color == "white" ? "\u{2659}" : "\u{265F}")
  end

  def moves
    if @moved
      subsequent_moves
    else
      first_move
    end
  end

  def first_move
    if @color == "white"
      subsequent_moves([[-2, 0]])
    else
      subsequent_moves([[2,0]])
    end
  end

  def subsequent_moves (arr = [])
    moves = []
    steps = arr
    if @color == "white"
      steps += [[-1, -1], [-1, 0], [-1, 1]]
    else
      steps += [[1, -1], [1, 0], [1, 1]]
    end
    steps.each do |step|
      x,y = curr_pos
      new_pos = [dir[0] + x, dir[1] + y]
      moves << new_pos if on_board?(new_pos)
    end

    moves
  end

end




# r = King.new("black", [3,2], "board")
# p r.moves
# b = Knight.new("white", [0,0], "board")
# p b.moves
# q = Queen.new("white", [7,6], "board")
# p q.moves
#puts "\u{2654}"

# k = King.new("white", [3,2], "b")
# puts k.symbol
# l = Pawn.new("black", [2,1], "f")
# puts l.symbol
