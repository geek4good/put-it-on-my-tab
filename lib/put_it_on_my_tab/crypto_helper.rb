module PutItOnMyTab
  class CryptoHelper
    def initialize(password, salt = nil)
      @password = password
      @salt = salt
    end

    def authorize(hashed_password)
      hashed_password.eql?(Digest::SHA2.hexdigest(password))
    end

    def encrypt(string)
      cipher.encrypt
      cipher.pkcs5_keyivgen password, salt
      encrypted_strig = cipher.update(string)
      encrypted_strig << cipher.final
    end

    def decrypt(string)
      cipher.decrypt
      cipher.pkcs5_keyivgen password, salt
      encrypted_strig = cipher.update(string)
      encrypted_strig << cipher.final
    end

    def salt
      @salt ||= OpenSSL::Random.random_bytes(8)
    end

    private

    attr_reader :password

    def cipher
      @cipher ||= OpenSSL::Cipher.new 'AES-128-CBC'
    end
  end
end
