# This module is responsible for all reset passwords scenario
# starting from generating tokens to sending reset passwords
# email ending with authorizing the public token given in the
# reset link.

require 'openssl'

module Users
  module Passwords
    attr_accessor :pub_key

    MINIMUM_PASSWORD_LENGTH = 8
    DIGEST                  = 'SHA256'.freeze

    def self.digest(_col, value)
      key = KeyGenerator.generate_key('USERS reset_password_token')

      value.present? && OpenSSL::HMAC.hexdigest(DIGEST, key, value.to_s)
    end

    def generate_unique_token
      key = KeyGenerator.generate_key('USERS reset_password_token')

      loop do
        raw_data = SecureRandom.hex(20)
        token    = OpenSSL::HMAC.hexdigest(DIGEST, key, raw_data)
        break [raw_data, token] unless User.find_by(reset_password_token: token)
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

      true
    end

    def reset_password(new_password, new_password_confirmation)
      if new_password.present? && new_password == new_password_confirmation
        self.password              = new_password
        self.password_confirmation = new_password_confirmation

        save
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

    def token_not_expired_and_reset_success?(user_params)
      reset_password_period_within_range? &&
        reset_password(user_params[:password], user_params[:password_confirmation])
    end
  end
end
