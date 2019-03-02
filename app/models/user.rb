class User < ApplicationRecord
  include Users::Passwords 

  has_secure_password

  validates :password, presence: true,
                       confirmation: true,
                       length: { minimum: MINIMUM_PASSWORD_LENGTH, allow_blank: true },
                       allow_nil: true
  validates :name,     presence: true, length: { minimum: 5 }, unless: -> { name == initial_name }
  validates :email,    presence: true,
                       uniqueness: true,
                       format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :reset_password_token, uniqueness: true, allow_blank: true

  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome_email.deliver_later
  end

  def initial_name
    email.split('@').first
  end
end
