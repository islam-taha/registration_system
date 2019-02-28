class User < ApplicationRecord
  has_secure_password

  validates :name,  presence: true, length: { minimum: 5 }
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
end
