require 'rails_helper'

RSpec.describe Specification, :type => :model do
  describe "Validations" do
    it "has a valid factory" do
      specification = build(:specification)
      expect(specification).to be_valid
    end

    it "it invalid without a property" do
      specification = build(:specification, property: nil)
      specification.valid?
      expect(specification.errors[:property]).to include("can't be blank")
    end

    it "it invalid without a value" do
      specification = build(:specification, value: nil)
      specification.valid?
      expect(specification.errors[:value]).to include("can't be blank")
    end

    it "it invalid without a unit of measure (uom)" do
      specification = build(:specification, uom: nil)
      specification.valid?
      expect(specification.errors[:uom]).to include("can't be blank")
    end

    it "it invalid without a commodity" do
      specification = build(:specification, commodity: nil)
      specification.valid?
      expect(specification.errors[:commodity]).to include("can't be blank")
    end
  end

  describe "Associations" do
    it "belongs to a commodity" do
      assoc = Specification.reflect_on_association(:commodity)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
