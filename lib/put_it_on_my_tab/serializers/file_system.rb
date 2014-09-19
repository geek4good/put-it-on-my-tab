require "securerandom"
require "yaml"

module PutItOnMyTab
  module Serializers
    class FileSystem
      DEFAULT_STORE_DIR = Dir.pwd

      attr_reader :store_dir

      def initialize(options = {})
        @store_dir = options.fetch(:store_dir, DEFAULT_STORE_DIR)
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
        { "title" => note.title, "body" => note.body }.to_yaml
      end
    end
  end
end
