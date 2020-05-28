class UserMailer < ApplicationMailer
  default from: "cat-rental-admin@example.com"

  # Any instance variuables i make availble here can be made available in views
  def welcome_email(user)
    @user = user
    # @url =
    #selecting user.username since they dotn have email addresses
    # Body of the email come from views/user_mailer
    mail(to: @user.user_name, subject: "Welcome to Catz 4 Rent!")
  end
end
