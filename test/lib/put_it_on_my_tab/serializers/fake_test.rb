require "test_helper"

module PutItOnMyTab
  describe Serializers::Fake do
    subject { Serializers::Fake.new }

    it { assert_equal 42, subject.store(Note.new("title", "body")) }
    it { assert_equal "Religion", subject.retrieve(42).title }
    it { assert_equal "Atheism is a non-prophet organization.", subject.retrieve(42).body }
  end
end
