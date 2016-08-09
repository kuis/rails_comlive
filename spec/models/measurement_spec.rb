require 'rails_helper'

RSpec.describe Measurement, :type => :model do
  describe "Validations" do
    it "has a valid factory" do
      measurement = build(:measurement)
      expect(measurement).to be_valid
    end

    it "it invalid without a property" do
      measurement = build(:measurement, property: nil)
      measurement.valid?
      expect(measurement.errors[:property]).to include("can't be blank")
    end

    it "it invalid without a value" do
      measurement = build(:measurement, value: nil)
      measurement.valid?
      expect(measurement.errors[:value]).to include("can't be blank")
    end

    it "it invalid without a unit of measure (uom)" do
      measurement = build(:measurement, uom: nil)
      measurement.valid?
      expect(measurement.errors[:uom]).to include("can't be blank")
    end

    it "it invalid without a commodity" do
      measurement = build(:measurement, commodity: nil)
      measurement.valid?
      expect(measurement.errors[:commodity]).to include("can't be blank")
    end
  end

  describe "Associations" do
    it "belongs to a commodity" do
      assoc = Measurement.reflect_on_association(:commodity)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
