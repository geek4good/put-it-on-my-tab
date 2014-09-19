require "test_helper"

module PutItOnMyTab
  describe CryptoHelper do
    subject { CryptoHelper.new(password).tap { |helper| helper.salt = salt } }

    let(:password) { "SUP3RS3CRE7" }
    let(:salt) { "\xA7\x97\\\"m\xFAQ\xF9" }

    describe "#authorized?" do
      it { assert subject.authorized?("a0b99d8e3defed75cdef291370838bd74dfc5ff911697ed9d91ec3354977e391") }
      it { refute subject.authorized?("This is plain wrong") }
    end

    describe "#encrypt" do
      let(:decrypted_message) { "What happens if you get scared half to death twice?" }

      it "makes sure none of the words appear in the output" do
        encrypted_message = subject.encrypt(decrypted_message)
        assert(decrypted_message.split.none? { |word| encrypted_message.include?(word) })
      end
    end

    describe "#decrypt" do
      let(:encrypted_message) { "What happens if you get scared half to death twice?" }

      it { assert_equal encrypted_message, subject.decrypt("rpCn\x16\xCD\xE8^\x04\xAE\xB9\xD9>\a\xCFG~[\x99\xED\xFD\xEE\"\xE4}\xD7a6\xBCz\xB5\xD97h\xDC\xF4\x135\"\x13o\x04\xE8}\xF3\x8B\xD7\xD2\xB8\xF3Ep.\x0E\x9F\xD7\xF3\x16C\xE4]G@\xBE") }
    end

    describe "#salt" do
      it { assert_equal salt, subject.salt }

      describe "when no salt specified" do
        let(:salt) { nil }

        it { refute_nil subject.salt }
      end
    end
  end
end
