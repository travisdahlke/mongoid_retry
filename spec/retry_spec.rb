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
  end

end