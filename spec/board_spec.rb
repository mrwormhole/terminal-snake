require 'board'

describe Board do
  let(:board){ Board.new(11) }

  describe "#new" do
    it "initializes board with cells" do
      expect(Board.new(40).cells).not_to be_nil
    end
  end

  describe "#create_board" do
    it "returns an array" do
      expect(board.cells).to be_instance_of(Array)
    end

    it "returns an array with given size" do
      expect(board.cells.length).to be_eql(11)
      expect(board.cells[0].length).to be_eql(11)
    end

    it "returns board full of dots" do
      expect(board.cells[0][0]).to eql('.')
    end
  end

  describe "#show_center_text" do
    it "shows game over on center of the board" do
      board.show_on_center("Game Over")
      expect(board.cells[board.size/2]).to be_eql([".", "G", "a", "m", "e", " ", "O", "v", "e", "r", "."])
    end
  end
end