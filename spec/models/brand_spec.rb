require 'rails_helper'

RSpec.describe Brand, :type => :model do
  describe "Validations" do
    it "has a valid factory" do
      brand = build(:brand)
      expect(brand).to be_valid
    end

    it "is invalid without a name" do
      brand = build(:brand, name: nil)
      brand.valid?
      expect(brand.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a description" do
      brand = build(:brand, description: nil)
      brand.valid?
      expect(brand.errors[:description]).to include("can't be blank")
    end

    it "is invalid without an app" do
      brand = build(:brand, app: nil)
      brand.valid?
      expect(brand.errors[:app]).to include("must exist")
    end
  end

  describe "Associations" do
    it "belongs to an app" do
      assoc = Brand.reflect_on_association(:app)
      expect(assoc.macro).to eq :belongs_to
    end

    it "has many users" do
      assoc = Brand.reflect_on_association(:users)
      expect(assoc.macro).to eq :has_many
    end

    it "has many children" do
      assoc = Brand.reflect_on_association(:children)
      expect(assoc.macro).to eq :has_many
    end

    it "has many standards" do
      assoc = Brand.reflect_on_association(:standards)
      expect(assoc.macro).to eq :has_many
    end
  end
end
