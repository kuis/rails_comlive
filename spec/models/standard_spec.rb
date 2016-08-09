require 'rails_helper'

RSpec.describe Standard, :type => :model do
  describe "Validations" do
    it "has a valid factory" do
      standard = build(:standard)
      expect(standard).to be_valid
    end

    it "is invalid without a name" do
      standard = build(:standard, name: nil)
      standard.valid?
      expect(standard.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a description" do
      standard = build(:standard, description: nil)
      standard.valid?
      expect(standard.errors[:description]).to include("can't be blank")
    end

    it "is invalid without an app" do
      standard = build(:standard, app: nil)
      standard.valid?
      expect(standard.errors[:app]).to include("can't be blank")
    end
  end

  describe "Associations" do
    it "belongs to an app" do
      assoc = Standard.reflect_on_association(:app)
      expect(assoc.macro).to eq :belongs_to
    end

    it "has many users" do
      assoc = Standard.reflect_on_association(:users)
      expect(assoc.macro).to eq :has_many
    end

    it "has many brands" do
      assoc = Standard.reflect_on_association(:brands)
      expect(assoc.macro).to eq :has_many
    end

    it "has many commodities" do
      assoc = Standard.reflect_on_association(:commodities)
      expect(assoc.macro).to eq :has_many
    end
  end
end
