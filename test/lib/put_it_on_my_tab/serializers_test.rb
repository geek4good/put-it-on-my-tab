require "test_helper"

module PutItOnMyTab
  describe Serializers do
    subject { Serializers }

    before { ENV.delete("SERIALIZER") }

    describe ".serializer" do
      it "defaults to file system serialization" do
        assert_instance_of Serializers::FileSystem, subject.serializer
      end

      it { ENV["SERIALIZER"] = "fake" and assert_instance_of Serializers::Fake, subject.serializer }
      it { ENV["SERIALIZER"] = "files" and assert_instance_of Serializers::FileSystem, subject.serializer }
      it { ENV["SERIALIZER"] = "nonexistent" and assert_raises(Serializers::UnknownSerializerError) { subject.serializer } }
    end
  end
end
