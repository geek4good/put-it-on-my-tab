require "base64"
require "securerandom"
require "yaml"

module PutItOnMyTab
  module Serializers
    class FileSystem
      DEFAULT_STORE_DIR = File.join(Dir.pwd, "notes")

      attr_reader :store_dir, :crypto_helper

      def initialize(options = {})
        @crypto_helper = options.fetch(:crypto_helper)
        @store_dir = ENV.fetch("FILE_STORE", DEFAULT_STORE_DIR)
      end

      def store(note)
        filename = generate_filename
        Dir.mkdir(store_dir) unless Dir.exists?(store_dir)
        File.write(filename, serialize(note))
        File.basename(filename)
      end

      def retrieve(basename)
        filename = filename(basename)
        deserialize(File.read(filename))
      end

      private

      def generate_filename
        loop do
          basename = SecureRandom.uuid
          filename = filename(basename)
          return filename unless File.exists?(filename)
        end
      end

      def filename(basename)
        File.join(store_dir, basename)
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

      def deserialize(serialized_note)
        note_data = YAML.load(serialized_note)
        meta_data = note_data["meta_data"]
        fail NoAuthorizationError unless crypto_helper.authorized?(meta_data["hashed_password"])

        crypto_helper.salt = Base64.decode64(meta_data["salt"])
        Note.new( note_data["title"], crypto_helper.decrypt(note_data["body"]))
      end
    end
  end
end
