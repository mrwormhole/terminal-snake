class Board
  attr_reader :size, :cells

  def initialize(size)
    @size = size
    @center = @size/2
    @cells = create_board
  end

  def create_board
    Array.new(@size) { Array.new(@size, ".") }
  end

  def show_on_center(text)
    cursor = @center
    if @center - text.length / 2 >= 0
      cursor = text.length / 2
    end

    i = 0
    text.chars.each do |char|
      cells[@center][@center - cursor + i] = char
      i += 1
    end
  end
end

