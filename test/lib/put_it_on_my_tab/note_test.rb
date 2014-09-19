require "test_helper"

module PutItOnMyTab
  describe Note do
    subject { Note.new(title, body) }

    let(:title) { "How to really enjoy spinach" }
    let(:body) { "Spinach tastes best when – just before eating – replaced by a juicy steak." }

    it { assert_equal title, subject.title }
    it { assert_equal body, subject.body }

    describe "#meta_data" do
      it { assert subject.meta_data.empty? }

      it "stores arbitrary data" do
        subject.meta_data[:foo] = "foo"
        subject.meta_data[:bar] = "bar"

        assert_equal({ :foo => "foo", :bar => "bar" }, subject.meta_data)
      end
    end
  end
end
