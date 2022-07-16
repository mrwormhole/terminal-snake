require 'food'

describe Food do
  let(:food){ Food.new(25, 25) }

  describe "#new" do
    it "initializes food with a position" do
      expect(food).not_to be_nil
      expect(food.x).not_to be_nil
      expect(food.y).not_to be_nil
    end
  end

  describe "#position" do
    it "returns food's position as array" do
      expect(food.position).to be_eql([food.x, food.y])
    end
  end
end
