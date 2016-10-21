require "rails_helper"

RSpec.describe NotificationMailer, :type => :mailer do
  describe "claim" do
    let(:user) { create(:user) }
    let(:ownership) { build(:ownership, parent: user.default_app)  }
    let(:mail) { NotificationMailer.claim(ownership) }

    it "renders the headers" do
      expect(mail.subject).to eq("New Brand Claim")
      expect(mail.to).to eq(["info@ntty.com"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("App")
      expect(mail.body.encoded).to match("Owner")
      expect(mail.body.encoded).to match("Brand")
    end
  end
end
