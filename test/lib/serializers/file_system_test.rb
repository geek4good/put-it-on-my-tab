require "tmpdir"
require "test_helper"

module PutItOnMyTab
  describe Serializers::FileSystem do
    subject { Serializers::FileSystem.new(options) }

    let(:options) { { :store_dir => store_dir, :crypto_helper => crypto_helper } }
    let(:store_dir) { Dir.mktmpdir }
    let(:crypto_helper) { CryptoHelper.new(password).tap { |helper| helper.salt = salt } }
    let(:password) { "SUP3RS3CRE7" }
    let(:salt) { "\xA7\x97\\\"m\xFAQ\xF9" }

    let(:note) { Note.new(title, body) }
    let(:title) { "Cats" }
    let(:body) { "Cat puns freak meowt. Seriously, I'm not kitten!" }

    after { FileUtils.remove_entry(store_dir) }

    describe "#store" do
      let(:note_id) { subject.store(note) }
      let(:filename) { File.join(store_dir, note_id) }

      it { assert File.exists?(filename) }
      it { assert File.read(filename).include?(title) }
      it { assert File.read(filename).include?("body") }
      it { refute File.read(filename).include?(body) }
    end

    describe "#retrieve" do
      let(:filename) { File.join(store_dir, basename) }
      let(:basename) { "testfile" }
      let(:yaml_data) { <<YAML }
---
title: Cats
body: !binary |-
  iXTf2VLEgp+KQzVXHLJAGzG0vCtUGhW+pYdDCkzJrohi8Ux+lTnXeX+pFHMf
  vZ6xVvXWYAaup+Cqf5rGpVngmw==
meta_data:
  hashed_password: a0b99d8e3defed75cdef291370838bd74dfc5ff911697ed9d91ec3354977e391
  salt: |
    p5dcIm36Ufk=
    end
YAML

      before { File.write(filename, yaml_data) }

      it { assert_equal title, subject.retrieve(basename).title }
      it { assert_equal body, subject.retrieve(basename).body }

      describe "when using an incorrect password" do
        let(:password) { "incorrect" }

        it { assert_raises(Serializers::UnauthorizedError) { subject.retrieve(basename) } }
      end
    end

    describe "when not specifying a storage directory" do
      let(:options) { { :crypto_helper => crypto_helper } }

      it { assert_equal Serializers::FileSystem::DEFAULT_STORE_DIR, subject.store_dir }
    end
  end
end
