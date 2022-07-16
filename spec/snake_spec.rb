require 'snake'

describe Snake do
  let(:snake){Snake.new(4,4, 4)}

  describe "#new" do
    it "initializes snake with parts" do
      expect(snake.parts).to be_kind_of(Array)
      expect(snake.parts.length).to be_eql(4)
    end

    it "initializes snake head" do
      expect(snake.head).not_to be_nil
      expect(snake.head).to be_kind_of(Array)
      expect(snake.head.length).to be_eql(2)
      expect(snake.head.first).to be_kind_of(Integer)
      expect(snake.head.last).to be_kind_of(Integer)
    end

    it "initializes snake body" do
      expect(snake.body).not_to be_nil
      expect(snake.body).to be_kind_of(Array)
      expect(snake.body.length).to be_eql(3)
      expect(snake.body.first).to be_kind_of(Array)
      expect(snake.body.last).to be_kind_of(Array)
    end

    it "initializes snake with length" do
      expect(snake.size).to be_eql(4)
    end

    it "initializes snake with direction" do
      expect(snake.direction).to be_eql(:left)
    end
  end

  describe "#create_snake" do
    it "returns an array" do
      expect(snake.parts).to be_instance_of(Array)
    end

    it "returns an array with given length" do
      expect(snake.parts.length).to be_eql(4)
      expect(snake.parts[0].length).to be_eql(2)
    end
  end

  describe "#move" do
    it "should add one part and remove the last one from the snake" do
      old_snake = snake
      new_head = [snake.parts.first.first, snake.parts.first.last]
      old_snake.parts.unshift(new_head).pop
      snake.move
      expect(snake.parts).to be_eql(old_snake.parts)
    end
  end

  describe "#turn" do
    it "should change snake's direction" do
      snake.turn('w')
      expect(snake.direction).to eql(:up)
      snake.turn('a')
      expect(snake.direction).to eql(:left)
      snake.turn('s')
      expect(snake.direction).to eql(:down)
      snake.turn('d')
      expect(snake.direction).to eql(:right)
    end
  end

  describe "#set_head" do
    it "updates snake's head position if snake mets wall" do
      snake_head = snake.head
      snake_head[0] = 2
      snake.set_head(0, 2)
      expect(snake.parts.first).to be_eql(snake_head)
    end
  end

  describe "#grow" do
    it "grows snake after food being eaten" do
      expect{snake.grow}.to change{snake.size}.from(4).to(5)
      expect{snake.grow}.to change{snake.parts.length}.from(5).to(6)
    end
  end
end