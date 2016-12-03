class MyPiece < Piece
  def initialize (point_array, board)
    @all_rotations = point_array
    @rotation_index = (0..(@all_rotations.size-1)).to_a.sample
    @color = All_Colors.sample
    @base_position = [5, 0] # [column, row]
    @board = board
    @moved = true
  end

  def self.next_piece (board)
    MyPiece.new(All_Pieces.sample, board)
  end

  def self.cheat_piece (board)
    MyPiece.new(Cheat_piece, board)
  end

  # class array holding all the pieces and their rotations
  Cheat_piece = [[[0, 0],[0, 0],[0, 0],[0, 0]]]

  All_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
                  rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
                  [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
                    [[0, 0], [0, -1], [0, 1], [0, 2]]],
                  rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
                  rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
                  rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
                  rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]),  # Z
                  # Added in 2:
                  rotations([[0, 0], [0, 0], [0, 1], [1, 0]]),             # 1
                  [[[0, 0], [-1, 0], [-2, 0], [1, 0], [2, 0]],             # 2
                    [[0, 0], [0, -1], [0, -2], [0, 1], [0, 2]]],
                  rotations([[0, 0], [-1, 0], [-1, -1], [1, 0], [0, -1]])] # 3
end

class MyBoard < Board
  def initialize (game)
    super
    @current_block = MyPiece.next_piece(self)
    @cheat = false
  end

  def next_piece
    puts @cheat
    @current_block = @cheat ? MyPiece.cheat_piece(self) : MyPiece.next_piece(self)
    @cheat = false
    @current_pos = nil
  end

  def rotate_180
    rotate_clockwise
    rotate_clockwise
  end

  def cheat
    if @score > 100
      @cheat = true
      @score -= 100
    end
  end
end

class MyTetris < Tetris
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    @root.bind('u', proc {@board.rotate_180})
    @root.bind('c', proc {@board.cheat})
  end
end
