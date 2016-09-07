class User < ApplicationRecord
  has_many :memberships
  has_many :apps, source: :member, source_type: "App", through: :memberships
  has_many :brands, source: :member, source_type: "Brand", through: :memberships
  has_many :standards, source: :member, source_type: "Standard", through: :memberships

  after_create :create_app

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider     = auth.provider
      user.uid          = auth.uid
      user.email        = auth.info.email
      user.first_name   = auth.info.first_name
      user.last_name    = auth.info.last_name
      user.oauth_token  = auth.credentials.token
      user.save!
    end
  end

  def accept_invite(token)
    invitation = Invitation.find_by(token: token, accepted: false)
    return if invitation.nil?
    self.apps << invitation.app
    invitation.update(accepted: true)
    return invitation
  end

  def default_app
    self.apps.find_by(default: true)
  end

  private

  def create_app
    app = self.apps.create(name: Faker::App.name, description: "App description", default: true)
    self.memberships.find_by(member_type: "App", member_id: app.id).update(owner: true)
  end

  #def assign_token
  #  loop do
  #    self.token = SecureRandom.base64.tr('+/=', 'Qrt')
  #    break unless User.exists?(token: token)
  #  end
  #end

end
