require "test_helper"

module PutItOnMyTab
  describe Serializers::Fake do
    subject { Serializers::Fake.new }

    describe "#store" do
      it { assert_equal 42, subject.store }
    end

    describe "#retrieve" do
      it { assert_equal "Religion", subject.retrieve(basename).title }
      it { assert_equal "Atheism is a non-prophet organization.", subject.retrieve(basename).body }
    end
  end
end
