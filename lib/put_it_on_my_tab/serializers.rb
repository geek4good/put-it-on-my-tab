require "put_it_on_my_tab/serializers/fake"
require "put_it_on_my_tab/serializers/file_system"

module PutItOnMyTab
  module Serializers
    class NoAuthorizationError < StandardError; end
    class UnknownSerializerError < StandardError; end

    def self.serializer(password = "")
      crypto_helper = PutItOnMyTab::CryptoHelper.new(password)
      serializer_class =
        case ENV["SERIALIZER"]
        when nil then PutItOnMyTab::Serializers::FileSystem
        when "fake" then PutItOnMyTab::Serializers::Fake
        when "files" then PutItOnMyTab::Serializers::FileSystem
        else fail UnknownSerializerError.new(%Q|'#{ENV["SERIALIZER"]}' does not exist|)
        end

      serializer_class.new(:crypto_helper => crypto_helper)
    end
  end
end
