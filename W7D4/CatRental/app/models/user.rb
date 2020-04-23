
class User < ApplicationRecord
  #gives me access to @password instance variable
  attr_reader :password

  validates :user_name, presence: true, uniqueness: true
  validates :password_digest, presence: { message: "Password can\'t be blank" }
  validates :session_token, presence: true, uniqueness: true

  #Either checks our @password instance variable on the first input to validate
    # length, or on future request when its pulled from db, it will appear
    # as nil, so will still pass.
  validates :password, length: { minimum:6, allow_nil: true }

  # line below is correct but i still need to add the method
  after_initialize :ensure_session_token

  #before anythign validated, form submitted ect, check for
  # session token
  before_validation :ensure_session_token

  has_many :requests,
      primary_key: :id,
      foreign_key: :user_id,
      class_name: :CatRentalRequest,
      dependent: :destroy

  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat,
    dependent: :destroy

    # Use this method in controller to make sure only if a person owns a cat
    # then they are alolowed to approve, or denyt, or edit/update
  def owns_cat?(cat)
    cat.user_id == self.id
  end



  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return user if user && user.is_password?(password)
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
    #turining our stored string digest back into obj so we can call method to
    #compare to submitted password
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token!
    # Resets our session token and outputs it so we can pass it to our
    #  session[:session_token] when creating a new session on login.
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end


end
