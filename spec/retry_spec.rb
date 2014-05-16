require 'spec_helper'

describe Mongoid::MongoidRetry do

  before(:all) do
    Thing.create_indexes
  end

  describe "#save_and_retry" do
    describe "when a document with the same key exists" do
      before(:each) do
        Thing.create(name: 'apple', color: 'red')
      end

      subject { Thing.new(name: 'apple', color: 'green') }

      it "should not raise an exception" do
        subject.save_and_retry
      end

      it "should find and update the document" do
        subject.save_and_retry
        Thing.all.last.color.should == 'green'
      end

      it "should not create a duplicate document" do
        subject.save_and_retry
        Thing.count.should == 1
      end
    end

    describe "with compound indexes" do
      before(:each) do
        Thing.create(name: 'apple', color: 'red', shape: 'round')
      end

      subject { Thing.new(name: 'grapefruit', color: 'red', shape: 'round') }

      it "should not raise an exception" do
        subject.save_and_retry
      end

      it "should find and update the document" do
        subject.save_and_retry
        Thing.all.last.name == 'block'
      end

      it "should not create a duplicate document" do
        subject.save_and_retry
        Thing.count.should == 1
      end
    end

    describe "with conflicting documents" do
      before(:each) do
        Thing.create(name: 'banana', color: 'yellow')
        Thing.create(name: 'apple', color: 'red')
      end

      subject { Thing.new(name: 'banana', color: 'red') }

      it "should raise error" do
        expect { subject.save_and_retry }.to raise_error
      end

      it "should delete conflicting document" do
        subject.save_and_retry(allow_delete: true)
        expect(Thing.count).to eq(1)
      end

      it "should save the new document" do
        subject.save_and_retry(allow_delete: true)
        expect(Thing.all.last.name).to eq('banana')
        expect(Thing.all.last.color).to eq('red')
      end

    end

  end

end
