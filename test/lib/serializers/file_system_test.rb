require "tmpdir"
require "test_helper"

module PutItOnMyTab
  describe Serializers::FileSystem do
    subject { Serializers::FileSystem.new(options) }

    let(:options) { { :store_dir => store_dir } }
    let(:store_dir) { Dir.mktmpdir }

    after { FileUtils.remove_entry(store_dir) }

    describe "#store" do
      let(:note) { Note.new(title, body) }
      let(:title) { "Cats" }
      let(:body) { "Cat puns freak meowt. Seriously, I'm not kitten!" }


      let(:note_id) { subject.store(note) }
      let(:filename) { File.join(store_dir, note_id) }

      it { assert File.exists?(filename) }
      it { assert File.read(filename).include?(title) }
      it { assert File.read(filename).include?(body) }
    end

    describe "for empty options" do
      let(:options) { {} }

      it { assert_equal Serializers::FileSystem::DEFAULT_STORE_DIR, subject.store_dir }
    end
  end
end
