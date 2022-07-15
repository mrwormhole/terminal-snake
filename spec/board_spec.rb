require 'board'

RSpec.describe Board, "#board" do
  describe "#new" do
    it "initializes gameboard with board" do
      expect(Board.new(40).cells).not_to be_nil
    end
  end

  describe "#create_board" do
    let(:board){ Board.new(40) }

    it "returns an array" do
      expect(board.cells).to be_instance_of(Array)
    end

    it "returns an array with given size" do
      expect(board.cells.size).to be_eql(40)
      expect(board.cells[0].size).to be_eql(40)
    end

    it "returns board full of dots" do
      expect(board.cells[0][0]).to eql('.')
    end
  end
end