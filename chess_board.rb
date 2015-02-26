require_relative './piece.rb'
require 'byebug'
class Board
  ROOKS = [[0, 0], [0, 7], [7, 0], [7, 7]]
  KNIGHTS = [[0, 1], [0, 6], [7, 1], [7, 6]]
  BISHOPS = [[0, 2], [0, 5], [7, 2], [7, 5]]
  QUEENS = [[0, 3], [7, 3]]
  KINGS = [[0, 4], [7, 4]]

  attr_reader :board, :white_pieces, :black_pieces

  def initialize(new_board)
    @black_pieces = []
    @white_pieces = []
    generate_board(new_board)
  end

  def in_check?(color)
    pieces = color == "white" ? @black_pieces : @white_pieces
    king_pos = get_king(color).pos
    pieces.compact.each do |piece|
      return true if piece.moves.include?(king_pos)
    end
    false
  end

  def dup
    board_dup = Board.new(false)
    @board.flatten.compact.each do |piece|
      new_piece = piece.class.new(piece.color, piece.pos, board_dup)
      board_dup[piece.pos] = new_piece
    end
    board_dup.group_colors
    board_dup
  end

  def move(start, end_pos)
    raise "There is no piece at the starting position." if self[start].nil?
    curr_piece = self[start]
    unless curr_piece.get_valid_moves.include?(end_pos)
      raise "The piece cannot move to end position."
    end
    curr_piece.pos = end_pos
    self[end_pos] = curr_piece
    self[start] = nil
  end

  def move!(start, end_pos)
    curr_piece = self[start]
    curr_piece.pos = end_pos
    self[end_pos] = curr_piece
    self[start] = nil
  end

  def [](pos)
    x,y = pos
    @board[x][y]
  end

  def []= (pos, value)
    x,y = pos
    @board[x][y] = value
  end

  def group_colors
    @board.flatten.compact.each do |piece|
      @black_pieces << piece if piece.color == "black"
      @white_pieces << piece if piece.color == "white"
    end
  end

  def generate_board(new_board)
    @board = Array.new(8) { Array.new(8) { nil } }
    return unless new_board
    set_pawns
    set_two_pieces(Rook)
    set_two_pieces(Knight)
    set_two_pieces(Bishop)
    set_two_pieces(Queen)
    set_two_pieces(King)
    group_colors
  end

  def get_king(color)
    pieces = (color == "white" ? @white_pieces : @black_pieces)
    pieces.find { |piece| piece.is_a?(King) }
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
      color = i < num ? "black" : "white"
      self[pos] = piece.new(color, pos , self)
    end
  end

  def set_pawns
    @board[1].each_with_index do |tile, i|
      @board[1][i] = Pawn.new("black", [1,i], self)
    end

    @board[6].each_with_index do |tile, i|
      @board[6][i] = Pawn.new("white", [6,i], self)
    end
  end

  def checkmate?(color)
    pieces = (color == "black" ? @black_pieces : @white_pieces)
    if in_check?(color)
      return pieces.none? do |piece|
        piece.get_valid_moves.length > 0
      end
    end

    false
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
#
# a = Board.new(true)
# a.move([6,5], [5,5])
# a.move([1,4], [3,4])
# a.move([6,6], [4,6])
# puts a.checkmate?("white")
# a.move([0,3],[4,7])
# a.render
# puts a.checkmate?("white")
