class User < ApplicationRecord
  validates :username, uniqueness: true
  has_secure_password
  def token_data
    {
      user_id: id,
      username:
    }
  end
end
