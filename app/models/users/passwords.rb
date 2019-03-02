require 'openssl'

module Users
  module Passwords
    attr_accessor :pub_key

    MINIMUM_PASSWORD_LENGTH = 8.freeze
    DIGEST                  = 'SHA256'.freeze

    def self.digest(col, value)
      value.present? && OpenSSL::HMAC.hexdigest(DIGEST, col.to_s, value.to_s)
    end

    def generate_unique_token
      loop do
        key   = SecureRandom.hex(20)
        token = OpenSSL::HMAC.hexdigest(DIGEST, 'reset_password_token', key)
        break [key, token] unless User.find_by(reset_password_token: token)
      end
    end

    def set_reset_password_token
      @pub_key, self.reset_password_token = generate_unique_token
      self.reset_password_token_sent_at   = Time.now.utc

      save(validate: false)
    end

    def send_reset_password_email
      UserMailer.with(user: self, token: @pub_key).reset_password.deliver_later
    end

    def send_reset_password_token_info
      set_reset_password_token
      send_reset_password_email

      self
    end

    def reset_password(new_password, new_password_confirmation)
      if new_password.present? && new_password == new_password_confirmation
        self.password              = new_password 
        self.password_confirmation = new_password_confirmation

        save(validate: true)
      else
        errors[:base] << 'Password and Password confirmation did not match'

        false
      end
    end

    def reset_password_period_within_range?
      reset_password_token_sent_at &&
        reset_password_token_sent_at.utc >=
          ActAsAuthorizable::RESET_PASSWORD_TOKEN_EXPIRY_PERIOD.ago.utc
    end
  end
end
