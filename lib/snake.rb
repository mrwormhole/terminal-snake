class Snake
  attr_reader :size, :direction, :position, :parts

  def initialize(board_max_x, board_max_y, size)
    @size = size
    @direction = :left
    @parts = []
    set_random_position(board_max_x, board_max_y)
    create_snake
  end

  def create_snake
    @size.times do |i|
      @parts.append([position[0], position[1] + i])
    end
  end

  def set_random_position(board_max_x, board_max_y)
    @position = [Random.rand(0..board_max_x-1), Random.rand(0..board_max_y-1)]
  end

  def head
    parts.first unless parts.nil?
  end

  def body
    parts[1..parts.length-1] unless parts.nil?
  end

  def grow
    @size += 1
    @parts.append(parts.last) unless parts.last.nil?
  end

  def set_head(index, value)
    head[index] = value
  end

  def turn(key_code)
    case key_code.chr.downcase
    when 'w'
      @direction = :up
    when 's'
      @direction = :down
    when 'a'
      @direction = :left
    when 'd'
      @direction = :right
    else
      @direction = :up
    end
  end

  def move
    new_head = [head.first,head.last]
    case direction
    when :left
      new_head[1] -= 1
    when :right
      new_head[1] += 1
    when :up
      new_head[0] -= 1
    when :down
      new_head[0] += 1
    else
      return
    end
    parts.unshift(new_head)
    parts.pop unless parts.nil?
  end
end