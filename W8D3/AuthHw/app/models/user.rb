class User < ApplicationRecord
  attr_reader :password

  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: { message: "Password can\'t be blank"}
  validates :password, length: { minimum:6, allow_nil: true}
  validates :session_token, presence: true, uniqueness: true

  before_validation :ensure_session_token

  def self.find_by_credentials(uname, pword)
      user = User.find_by(username: uname)
      return user if user && BCrypt::Password.new(user.passwrod_digest).is_poassword?(password)
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64
    # Returns a pseudoransom 16-digit string, helper method
  end

  def reset_session_token
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
    #way to just call it once, cached in a sense
  end


  # Helper methods to make interacting with User object easier.
  # we make @password an instance variable, but never save to db, so we can still
  # validate it above to ensure length.

  # validations do not need to check only database columns; you can apply a validation to any attribute.
  # the password will be around when first signing in, but upod further
  # instances it wont exist
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
