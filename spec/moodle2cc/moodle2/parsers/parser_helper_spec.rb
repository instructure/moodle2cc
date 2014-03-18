require 'spec_helper'

describe Moodle2CC::Moodle2::Parsers::ParserHelper do
  class HelperClass
    include Moodle2CC::Moodle2::Parsers::ParserHelper
  end

  subject { HelperClass.new }

  describe "#activity_directories" do
    it "returns a list of directories associated with an activity type" do
      dirs = subject.activity_directories(moodle2_backup_dir, 'forum')
      expect(dirs.size).to eq 1
      expect(dirs.first).to eq 'activities/forum_1'
    end
  end

  describe "#parse_text" do
    let(:child_node) {
      double.tap do |double|
        double.stub(:text) { 'value' }
      end
    }

    let(:parent_node) {
      double.tap do |double|
        double.stub(:%) { child_node }
        double.stub(:at_xpath) { child_node}
      end
    }

    it "retrieves the text from a nokogiri node" do
      expect(subject.parse_text(parent_node, 'path')).to eq 'value'
      expect(parent_node).to have_received(:%).with('path')
    end

    it "returns nil if the requested path does not exist" do
      parent_node.stub(:%) { nil }
      expect(subject.parse_text(parent_node, 'path')).to eq nil
    end

    it "replaces the XML_NULL_VALUE with nil" do
      child_node.stub(:text) { Moodle2CC::Moodle2::Parsers::ParserHelper::XML_NULL_VALUE }
      expect(subject.parse_text(parent_node, 'path')).to eq nil
    end

    it "uses #at_xpath when ns is true" do
      expect(subject.parse_text(parent_node, 'path', true)).to eq 'value'
      expect(parent_node).to have_received(:at_xpath).with('path')
    end

  end

  describe "#parse_boolean" do
    let(:child_node) {
      double.tap do |double|
        double.stub(:text) { 'value' }
      end
    }

    let(:parent_node) {
      double.tap do |double|
        double.stub(:%) { child_node }
      end
    }

    it "parses 1 as boolean true" do
      child_node.stub(:text) { '1' }
      expect(subject.parse_boolean(parent_node, 'path')).to eq true
    end

    it "parses 0 as boolean false" do
      child_node.stub(:text) { '0' }
      expect(subject.parse_boolean(parent_node, 'path')).to eq false
    end

    it "parses 'false' as boolean false" do
      child_node.stub(:text) { 'false' }
      expect(subject.parse_boolean(parent_node, 'path')).to eq false
    end

    it "parses 'true' as boolean true" do
      child_node.stub(:text) { 'true' }
      expect(subject.parse_boolean(parent_node, 'path')).to eq true
    end

    it "parses nil as boolean false" do
      child_node.stub(:text) { nil }
      expect(subject.parse_boolean(parent_node, 'path')).to eq false
    end

  end

end
