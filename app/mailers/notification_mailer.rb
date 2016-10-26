class NotificationMailer < ApplicationMailer
  def claim(ownership)
    @parent = ownership.parent
    @child = ownership.child
    @type = @child.class.to_s

    mail to: "info@ntty.com", subject: "New #{@type} Claim"
  end

  def contact_message(name, email, message)
    @name = name
    @message = message

    mail to: "info@ntty.com", subject: "Someone contacted you", reply_to: email
  end
end
