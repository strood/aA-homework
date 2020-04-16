class User < ApplicationRecord
  #gives me access to @password instance variable
  attr_reader :password

  validates :username, presence: true, uniqueness: true

  #Changes default error message so it doesnt say pasword_digest, but Password
  validates :password_digest, presence: { message: "Password can\'t be blank"}

  #Either checks our @password instance variable on the first input to validate
  # length, or on future request when its pulled from db, it will appear
  # as nil, so will still pass.
  validates :password, length: { minimum:6, allow_nil: true}
  validates :session_token, presence: true, uniqueness: true

  #makes sure a session token gets set, if not already
  after_initialize :ensure_session_token

  #before anythign validated, form submitted ect, check for
  # session token
  before_validation :ensure_session_token

  def self.find_by_credentials(username, password)
      user = User.find_by(username: username)
      return user if user && user.is_password?(password)
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

  private

  def ensure_session_token
    # we must be sure to use the ||= operator instead of = or ||, otherwise
    # we will end up with a new session token every time we create
    # a new instance of the User class. This includes finding it in the DB!
    self.session_token ||= User.generate_session_token

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
