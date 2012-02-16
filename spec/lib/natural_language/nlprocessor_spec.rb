require 'spec_helper'

describe NLProcessor do
  describe NLProcessor::Task do
    describe "#name" do
      it "should raise empty NLP query exception" do
        expect { NLProcessor::Task.new("") }.should raise_exception
      end

      it "should have name set" do
        task = NLProcessor::Task.new("buy milk")
        task.name.should == "buy milk"
      end

      xit "should have no dangling by" do
        task = NLProcessor::Task.new("start project by tomorrow")
        tomorrow = 1.day.from_now.beginning_of_day
        task.name.should_not match(/by/)
      end
    end

    describe "#start" do
      it "should have no start date" do
        task = NLProcessor::Task.new("sleep")
        task.start.should be_nil
      end

      it "should have start date tomorrow" do
        task = NLProcessor::Task.new("start project tomorrow")
        tomorrow = Chronic.parse("midnight")
        task.start.should == tomorrow
      end

      xit "should have start date = tomorrow @ 10am given advanced by syntax" do
        task = NLProcessor::Task.new("get to work by 10am tomorrow")
        future_time = Chronic.parse("tomorrow at 10am")
        task.start.should == future_time
      end
    end

    describe "#set_subject_and_location" do
      it "sets the subject regardless" do
        task = NLProcessor::Task.new("eat dinner")
        task.subject.should == "eat dinner"
      end

      it "should not have location" do
        task = NLProcessor::Task.new("eat dinner")
        task.location.should be_nil
      end

      it "should have subject and location set" do
        task = NLProcessor::Task.new("eat dinner at subway")
        task.location.should_not be_nil
        task.subject.should == "eat dinner"
      end

      it "should have category = supermarket" do
        task = NLProcessor::Task.new("buy milk at the supermarket")
        task.location.should be_nil
        task.category.should == "supermarket"
        task.subject.should == "buy milk"
      end

      it "should have location = whole foods given from syntax" do
        task = NLProcessor::Task.new("pick up bread, milk and eggs from whole foods")
        task.location.should == "whole foods"
        task.subject.should == "pick up bread milk and eggs"
      end
    end
  end
end
