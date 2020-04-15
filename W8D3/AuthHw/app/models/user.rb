class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: { message: "Password can\'t be blank"}
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum:6, allow_nil: true}
  before_validation :ensure_session_token

  attr_reader :password

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

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
end
