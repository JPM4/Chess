class Piece
  DIAGONALS =  [[-1,-1], [1,-1], [-1,1], [1,1]]
  LATERALS = [[0,1], [1,0], [-1,0], [0,-1]]

  attr_accessor :pos
  attr_reader :symbol, :color

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
  end

  def get_valid_moves
    @valid_moves = moves.reject {|move| move_into_check?(move) }
  end

  def move_into_check?(end_pos)
    board_dup = @board.dup
    board_dup.move!(@pos, end_pos)
    board_dup.in_check?(@color)
  end

  def on_board?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def piece_there?(pos)
    !@board[pos].nil?
  end

  def ally?(pos)
    if @board[pos].color == @color
      true
    else
      false
    end
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
        if on_board?(new_pos)
           if !piece_there?(new_pos)
             moves << new_pos
           elsif ally?(new_pos)
             break
           else
             moves << new_pos
             break
           end
         end
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
      if on_board?(new_pos)
         if !piece_there?(new_pos)
           moves << new_pos
           next
         elsif ally?(new_pos)
           next
         else
           moves << new_pos
         end
       end
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

  def moved?
    color == "white" ? pos[0] != 6 : pos[0] != 1
  end

  def moves
    if moved?
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

  def diagonal_opponents
    if @color == "white"
      steps = [[-1, -1], [-1, 1]]
    else
      steps = [[1, -1], [1, 1]]
    end
    @possible_moves = []
    steps.select do |step|
      x, y = @pos
      new_pos = [x + step[0], y + step[1]]
      @possible_moves << new_pos if piece_there?(new_pos) && !ally?(new_pos)
    end
  end

  def subsequent_moves(arr = [])
    diagonal_opponents
    x,y = @pos
    steps = arr
    if @color == "white"
      steps += [[-1, 0]]
    else
      steps += [[1, 0]]
    end
    steps.each do |step|
      new_pos = [step[0] + x, step[1] + y]
      @possible_moves << new_pos if on_board?(new_pos) && !piece_there?(new_pos)
    end

    @possible_moves
  end

end
