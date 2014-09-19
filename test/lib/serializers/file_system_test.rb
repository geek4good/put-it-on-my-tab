require "tmpdir"
require "test_helper"

module PutItOnMyTab
  describe Serializers::FileSystem do
    subject { Serializers::FileSystem.new(options) }

    let(:options) { { :store_dir => store_dir, :crypto_helper => crypto_helper } }
    let(:store_dir) { Dir.mktmpdir }
    let(:crypto_helper) { CryptoHelper.new(password, salt) }
    let(:password) { "SUP3RS3CRE7" }
    let(:salt) { "\xA7\x97\\\"m\xFAQ\xF9" }

    after { FileUtils.remove_entry(store_dir) }

    describe "#store" do
      let(:note) { Note.new(title, body) }
      let(:title) { "Cats" }
      let(:body) { "Cat puns freak meowt. Seriously, I'm not kitten!" }
      let(:encrypted_body) { "{@v\x8Ba\xD2M\x16\x1EtR|\x10^\xAC\xFF\xC3^\xE6\xE8\x15\xFE\xC0\x91\xCA*%\xD7Fq\xB0\xEA\xF7\xFE\x9E^\x92\xF8\xE4\t\a8l\xEC\x11\xC2\f\v#sU\xB3\xB6\x06\xD4\x9Fm\xDE\xD5\x9C\xCE\xD5m\x04" }


      let(:note_id) { subject.store(note) }
      let(:filename) { File.join(store_dir, note_id) }

      it { assert File.exists?(filename) }
      it { assert File.read(filename).include?(title) }
      it { assert File.read(filename).include?("body") }
      it { refute File.read(filename).include?(body) }
    end

    describe "when not specifying a storage directory" do
      let(:options) { { :crypto_helper => crypto_helper } }

      it { assert_equal Serializers::FileSystem::DEFAULT_STORE_DIR, subject.store_dir }
    end
  end
end
