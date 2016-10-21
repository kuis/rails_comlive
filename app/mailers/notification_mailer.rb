class NotificationMailer < ApplicationMailer
  def claim(ownership)
    @parent = ownership.parent
    @child = ownership.child
    @type = @child.class.to_s

    mail to: "info@ntty.com", subject: "New #{@type} Claim"
  end
end
