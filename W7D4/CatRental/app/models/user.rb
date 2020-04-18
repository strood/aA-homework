class User < ApplicationRecord

  validates :user_name, presence: true, uniqueness: true
  validates :password_digest, :session_token, presence: true
  # line below is correct but i still need to add the method
  after_initialize :ensure_session_token

  def password=(password)

  end

  def is_password?(password)

  end

  def self.find_by_credentials(user_name, password)

  end

  def reset_session_token

  end

  def ensure_session_token

  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
