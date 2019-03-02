# This module is used for generating private keys with specified salts

module KeyGenerator
  SECRET = ENV['SECRET_TOKEN'].freeze

  class << self
    def generate_key(salt, key_size = 64)
      OpenSSL::PKCS5.pbkdf2_hmac_sha1(SECRET, salt, 2**16, key_size)
    end
  end
end
