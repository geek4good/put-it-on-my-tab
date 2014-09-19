require "base64"
require "securerandom"
require "yaml"

module PutItOnMyTab
  module Serializers
    class FileSystem
      DEFAULT_STORE_DIR = Dir.pwd

      attr_reader :store_dir, :crypto_helper

      def initialize(options = {})
        @store_dir = options.fetch(:store_dir, DEFAULT_STORE_DIR)
        @crypto_helper = options.fetch(:crypto_helper)
      end

      def store(note)
        filename = generate_filename
        File.write(filename, serialize(note))
        File.basename(filename)
      end

      private

      def generate_filename
        loop do
          filename = File.join(store_dir, SecureRandom.uuid)
          return filename unless File.exists?(filename)
        end
      end

      def serialize(note)
        {
          "title" => note.title,
          "body" => crypto_helper.encrypt(note.body),
          "meta_data" => {
            "hashed_password" => crypto_helper.hashed_password,
            "salt" => Base64.encode64(crypto_helper.salt)
          }
        }.to_yaml
      end
    end
  end
end
