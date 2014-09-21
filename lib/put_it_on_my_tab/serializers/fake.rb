module PutItOnMyTab
  module Serializers
    class Fake
      def initialize(options = {})
      end

      def store(note)
        42
      end

      def retrieve(id)
        Note.new("Religion", "Atheism is a non-prophet organization.")
      end
    end
  end
end

