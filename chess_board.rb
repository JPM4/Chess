require_relative './chess_game.rb'
require_relative './piece.rb'

class Board
  ROOKS = [[0, 0], [0, 7], [7, 0], [7, 7]]
  KNIGHTS = [[0, 1], [0, 6], [7, 1], [7, 6]]
  BISHOPS = [[0, 2], [0, 5], [7, 2], [7, 5]]
  QUEENS = [[0, 3], [7, 3]]
  KINGS = [[0, 4], [7, 4]]

  attr_reader :board

  def initialize
    generate_board
    show_board
    group_colors
  end

  def in_check?(color)
    pieces = color == "white" ? @black_pieces : @white_pieces
    king_pos = get_king(color).pos
    pieces.each do |piece|
      return true if piece.get_valid_moves.include?(king_pos)
    end

    false
  end

  def group_colors
    @black_pieces = @board[0] + @board[1]
    @white_pieces = @board[6] + @board[7]
  end

  def generate_board
    @board = Array.new(8) { Array.new(8) { nil } }
    set_pawns
    set_two_pieces(Rook)
    set_two_pieces(Knight)
    set_two_pieces(Bishop)
    set_two_pieces(Queen)
    set_two_pieces(King)
  end

  def get_king(color)
    pieces = color == "white" ? @white_pieces : @black_pieces
    king = nil
    pieces.each do |piece|
      king = piece if piece.is_a?(King)
    end

    king
  end

  # def find_piece(color, type)
  #   pieces = color == "white" ? @white_pieces : @black_pieces
  #
  #
  # end

  def set_two_pieces(piece)
    if piece == Rook
      curr_pos = ROOKS
    elsif piece == Knight
      curr_pos = KNIGHTS
    elsif piece == Bishop
      curr_pos = BISHOPS
    elsif piece == Queen
      curr_pos = QUEENS
    else
      curr_pos = KINGS
    end

    num = curr_pos == KINGS || curr_pos == QUEENS ? 1 : 2

    curr_pos.each_with_index do |pos, i|
      x,y = pos
      color = i < num ? "black" : "white"
      board[x][y] = piece.new(color, [x, y], @board)
    end
  end

  def set_pawns
    board[1].each_with_index do |tile, i|
      board[1][i] = Pawn.new("black", [1,i], @board)
    end

    board[6].each_with_index do |tile, i|
      board[6][i] = Pawn.new("white", [6,i], @board)
    end
  end

  def render
    puts show_board
  end

  def show_board
    new_str = "   "
    @board.size.times do |i|
      new_str << i.to_s
      new_str << "  "
    end
    new_str << "\n"

    @board.each_with_index do |row, idx|
      new_str << idx.to_s << "  "
      row.each_with_index do |col, idx2|
        display = (col.nil? ? "-" : col.symbol)
        new_str << display << "  "
      end
      new_str << "\n"
    end
   new_str
  end


end

board = Board.new
board.in_check?("white")
