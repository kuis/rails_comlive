require 'rails_helper'

RSpec.describe Reference, :type => :model do
  describe "Validations" do
    it "has a valid factory" do
      reference = build(:reference)
      expect(reference).to be_valid
    end
    it "is invalid without a kind" do
      reference = build(:reference, kind: nil)
      reference.valid?
      expect(reference.errors[:kind]).to include("can't be blank")
    end
    it "is invalid without a source commodity" do
      reference = build(:reference, source_commodity_id: nil)
      reference.valid?
      expect(reference.errors[:source_commodity_id]).to include("can't be blank")
    end
    it "is invalid without a target commodity" do
      reference = build(:reference, target_commodity_id: nil)
      reference.valid?
      expect(reference.errors[:target_commodity_id]).to include("can't be blank")
    end
    it "is invalid without a description" do
      reference = build(:reference, description: nil)
      reference.valid?
      expect(reference.errors[:description]).to include("can't be blank")
    end
    it "is invalid without an app" do
      reference = build(:reference, app_id: nil)
      reference.valid?
      expect(reference.errors[:app]).to include("can't be blank")
    end
    it "is invalid if kind is not in allowed list" do
      reference = build(:reference, kind: "apple")
      reference.valid?
      expect(reference.errors[:kind]).to include("is not allowed")
    end
    it "is invalid without a commodity reference" do
      reference = build(:reference, commodity_reference_id: nil)
      reference.valid?
      expect(reference.errors[:commodity_reference_id]).to include("can't be blank")
    end
    it "is public by default" do
      reference = build(:reference)
      expect(reference.visibility).to eq "publicized"
    end
  end


  describe "Associations" do

    it "belongs to app" do
      assoc = Reference.reflect_on_association(:app)
      expect(assoc.macro).to eq :belongs_to
    end

    it "belongs to a commodity reference" do
      assoc = Reference.reflect_on_association(:commodity_reference)
      expect(assoc.macro).to eq :belongs_to
    end

    it "belongs to source commodity" do
      assoc = Reference.reflect_on_association(:source_commodity)
      expect(assoc.macro).to eq :belongs_to
    end

    it "belongs to target commodity" do
      assoc = Reference.reflect_on_association(:target_commodity)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
