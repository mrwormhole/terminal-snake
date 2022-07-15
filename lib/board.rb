class Board
  attr_reader :size, :cells

  def initialize(size)
    @size = size
    @cells = create_board
  end

  def create_board
    Array.new(size) { Array.new(size, ".") }
  end
end

