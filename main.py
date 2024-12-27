import curses
from _curses import window as CursesWindow
import random
import time
from enum import auto, Enum
import sys


class Board:
    size: int
    cells: list[list[str]]

    def __init__(self, size: int):
        self.size = size
        self.cells = self.create_board()

    def create_board(self) -> list[list[str]]:
        return [["."] * self.size for _ in range(self.size)]

    def reset(self):
        self.cells = self.create_board()


class Food:
    x: int
    y: int

    def __init__(self, board_width: int, board_height: int):
        self.x = random.randint(0, board_width - 1)
        self.y = random.randint(0, board_height - 1)


class Direction(Enum):
    LEFT = auto()
    RIGHT = auto()
    DOWN = auto()
    UP = auto()


class Snake:
    size: int
    position: list[int]
    parts: list[list[int]]
    direction: Direction

    def __init__(self, board_width: int, board_height: int, size: int):
        self.size = size
        self.position = [
            random.randint(0, board_width - 1),
            random.randint(self.size, board_height - self.size - 1),
        ]
        self.parts = [
            [self.position[0], self.position[1] + i] for i in range(self.size)
        ]
        self.direction = Direction.LEFT

    @property
    def head(self) -> list[int] | None:
        return self.parts[0] if self.parts else None

    def set_head(self, index: int, value: int):
        self.head[index] = value

    @property
    def body(self) -> list[list[int]] | None:
        return self.parts[1:] if self.parts else None

    def grow(self):
        self.size += 1
        if self.parts:
            self.parts.append(self.parts[-1])

    def turn(self, key_code: str):
        match key_code:
            case "w" if self.direction != Direction.DOWN:
                self.direction = Direction.UP
            case "s" if self.direction != Direction.UP:
                self.direction = Direction.DOWN
            case "a" if self.direction != Direction.RIGHT:
                self.direction = Direction.LEFT
            case "d" if self.direction != Direction.LEFT:
                self.direction = Direction.RIGHT

    def move(self):
        if not self.head or not self.parts:
            return

        new_head = self.head.copy()
        match self.direction:
            case Direction.LEFT:
                new_head[1] -= 1
            case Direction.RIGHT:
                new_head[1] += 1
            case Direction.UP:
                new_head[0] -= 1
            case Direction.DOWN:
                new_head[0] += 1

        self.parts.insert(0, new_head)
        self.parts.pop()


class GameState(Enum):
    NONE = auto()
    IN_GAME = auto()
    GAME_OVER = auto()
    GAME_QUIT = auto()


class Game:
    board: Board
    snake: Snake
    food: Food
    state: GameState
    window: CursesWindow

    def __init__(self, board_size: int = 21, snake_size: int = 4):
        self.board = Board(board_size)
        self.snake = Snake(board_size, board_size, snake_size)
        self.food = Food(board_size, board_size)
        self.state = GameState.NONE

        w: CursesWindow = curses.initscr()
        curses.start_color()
        curses.init_pair(1, curses.COLOR_GREEN, curses.COLOR_BLACK)
        curses.init_pair(2, curses.COLOR_RED, curses.COLOR_BLACK)
        curses.noecho()  # Prevent key presses from being displayed on screen
        curses.curs_set(0)  # Hide the cursor
        self.window = w

    def run(self):
        self.show_start_screen()
        self.show_game_screen()
        if self.state == GameState.GAME_OVER:
            self.show_exit_screen("Game Over")
        if self.state == GameState.GAME_QUIT:
            self.show_exit_screen("Game Quit")

    def show_start_screen(self):
        logo = """
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
"""
        self.window.addstr(0, 0, logo)
        self.window.nodelay(False)  # Make getch() blocking
        while True:
            keycode: int = self.window.getch()
            if keycode not in (ord("q"), ord("s")):
                continue
            key = chr(keycode).lower()
            if key == "q":
                self.state = GameState.GAME_QUIT
                break
            elif key == "s":
                self.state = GameState.IN_GAME
                break
        self.window.nodelay(True)  # Make getch() non-blocking

    def show_game_screen(self):
        self.window.clear()
        while self.state == GameState.IN_GAME:
            start_time = time.time()
            self.input()
            self.update()
            self.draw()
            elapsed = time.time() - start_time
            if elapsed < 0.1:  # 100ms per frame
                time.sleep(0.1 - elapsed)

    def show_exit_screen(self, text: str):
        self.board.reset()
        center = self.board.size // 2
        offset = center - len(text) // 2
        for i, char in enumerate(text):
            self.board.cells[center][offset + i] = char
        self.draw()

    def input(self):
        keycode: int = self.window.getch()
        if keycode not in (ord("q"), ord("w"), ord("s"), ord("a"), ord("d")):
            return
        key = chr(keycode).lower()
        match key:
            case "q":
                self.state = GameState.GAME_QUIT
            case "w" | "a" | "s" | "d":
                self.snake.turn(key)

    def update(self):
        self.snake.move()
        self.handle_walls()
        self.handle_food()
        self.handle_collision()
        self.board.reset()
        self.board.cells[self.food.x][self.food.y] = "o"
        for x, y in self.snake.parts:
            self.board.cells[x][y] = "x"

    def draw(self):
        self.window.addstr(0, 0, f"Snake size is: {self.snake.size} |  [Q]uit")
        self.window.addstr(1, 0, "-" * 41)
        for i, row in enumerate(self.board.cells):
            for j, cell in enumerate(row):
                if cell == "x":
                    self.window.addstr(i + 2, j * 2, "■", curses.color_pair(1))
                elif cell == "o":
                    self.window.addstr(i + 2, j * 2, "●", curses.color_pair(2))
                elif cell == ".":
                    self.window.addstr(i + 2, j * 2, ".")
                else:
                    self.window.addstr(i + 2, j * 2, cell)
        self.window.refresh()

    def handle_walls(self):
        if self.snake.head[1] > self.board.size - 1:
            self.snake.set_head(1, 0)
        if self.snake.head[1] < 0:
            self.snake.set_head(1, self.board.size - 1)
        if self.snake.head[0] > self.board.size - 1:
            self.snake.set_head(0, 0)
        if self.snake.head[0] < 0:
            self.snake.set_head(0, self.board.size - 1)

    def handle_food(self):
        if self.snake.head[0] == self.food.x and self.snake.head[1] == self.food.y:
            self.snake.grow()
            self.food = Food(self.board.size, self.board.size)

    def handle_collision(self):
        if self.snake.head in self.snake.body:
            self.state = GameState.GAME_OVER


if __name__ == "__main__":
    game: Game
    if len(sys.argv) > 1:
        game = Game(board_size=int(sys.argv[1]))
    else:
        game = Game()
    try:
        game.run()
    except KeyboardInterrupt:
        pass
