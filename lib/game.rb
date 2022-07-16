require 'tty-reader'
require_relative 'board'
require_relative 'snake'
require_relative 'food'

module GameState
  NONE = 0
  IN_GAME = 1
  GAME_OVER = 2
  GAME_QUIT = 3
end

class Game
  attr_reader :board, :snake, :food

  def initialize(board_size = 11, snake_size = 4)
    @board = Board.new(board_size)
    @snake = Snake.new(board_size, board_size, snake_size)
    @food = Food.new(board_size, board_size)
    @reader = TTY::Reader.new
    @state = GameState::NONE
  end

  def run
    show_start_screen
    show_game_screen
    show_exit_screen("Game Over") if @state.eql? GameState::GAME_OVER
    show_exit_screen("Game Quit") if @state.eql? GameState::GAME_QUIT
  end

  def show_exit_screen(text)
    @board.reset
    @board.show_on_center(text)
    draw
  end

  def show_start_screen
    loop do
      system('clear')
      puts "\n
.........................................................................................
.........................................................................................
   SSSSSSSSSSSSSSS                                   kkkkkkkk
 SS:::::::::::::::S                                  k::::::k
S:::::SSSSSS::::::S                                  k::::::k
S:::::S     SSSSSSS                                  k::::::k
S:::::S          nnnn  nnnnnnnn      aaaaaaaaaaaaa    k:::::k    kkkkkkk eeeeeeeeeeee
S:::::S          n:::nn::::::::nn    a::::::::::::a   k:::::k   k:::::kee::::::::::::ee
 S::::SSSS       n::::::::::::::nn   aaaaaaaaa:::::a  k:::::k  k:::::ke::::::eeeee:::::ee
  SS::::::SSSSS  nn:::::::::::::::n           a::::a  k:::::k k:::::ke::::::e     e:::::e
    SSS::::::::SS  n:::::nnnn:::::n    aaaaaaa:::::a  k::::::k:::::k e:::::::eeeee::::::e
       SSSSSS::::S n::::n    n::::n  aa::::::::::::a  k:::::::::::k  e:::::::::::::::::e
            S:::::Sn::::n    n::::n a::::aaaa::::::a  k:::::::::::k  e::::::eeeeeeeeeeeq
            S:::::Sn::::n    n::::na::::a    a:::::a  k::::::k:::::k e:::::::e
SSSSSSS     S:::::Sn::::n    n::::na::::a    a:::::a k::::::k k:::::ke::::::::e
S::::::SSSSSS:::::Sn::::n    n::::na:::::aaaa::::::a k::::::k  k:::::ke::::::::eeeeeeee
S:::::::::::::::SS n::::n    n::::n a::::::::::aa:::ak::::::k   k:::::kee:::::::::::::e
 SSSSSSSSSSSSSSS   nnnnnn    nnnnnn  aaaaaaaaaa  aaaakkkkkkkk    kkkkkkk eeeeeeeeeeeeee
.....................................Press [S]tart.......................................
.....................................Press [Q]uit........................................
      "
      c = @reader.read_char.downcase
      case c
      when "q"
        @state = GameState::GAME_QUIT
        break
      when "s"
        @state = GameState::IN_GAME
        break
      end
    end
  end

  def show_game_screen
    while @state == GameState::IN_GAME
      input
      update
      draw
    end
  end

  def input
    c = @reader.read_keypress(nonblock: true)
    case c
    when 'q'
      @state = GameState::GAME_QUIT
    when 'w', 'a', 's', 'd'
      @snake.turn(c)
    end
  end

  def update
    update_snake
    @board.reset
    @board.cells[food.x][food.y] = 'o'
    @snake.parts.each do |part|
      @board.cells[part.first][part.last] = 'x'
    end
  end

  def draw
    system('clear')
    puts "Snake size is: #{snake.size} |  [Q]uit"
    puts 41.times.collect{"-"}.join
    @board.cells.each do
    |row| puts row.each{|item| item}.join(" ")
    end
  end

  def update_snake
    @snake.move
    check_if_snake_met_wall
    check_if_snake_ate_food
    check_if_snake_ate_itself
  end

  def check_if_snake_met_wall
    @snake.set_head(1,0) if @snake.head[1] > @board.size-1
    @snake.set_head(1, @board.size-1) if @snake.head[1] < 0
    @snake.set_head(0, 0) if @snake.head[0]  > @board.size-1
    @snake.set_head(0, @board.size-1) if @snake.head[0] < 0
  end

  def check_if_snake_ate_food
    if @snake.head[0] == @food.x && @snake.head[1] == @food.y
      @snake.grow
      @food = Food.new(@board.size, @board.size)
    end
  end

  def check_if_snake_ate_itself
    if @snake.body.include? @snake.head
      @state = GameState::GAME_OVER
    end
  end
end