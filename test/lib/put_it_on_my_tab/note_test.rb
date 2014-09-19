require "test_helper"

module PutItOnMyTab
  describe Note do
    subject { Note.new(title, body) }

    let(:title) { "How to really enjoy spinach" }
    let(:body) { "Spinach tastes best when – just before eating – replaced by a juicy steak." }

    it { assert_equal title, subject.title }
    it { assert_equal body, subject.body }
  end
end
