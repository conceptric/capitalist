require File.dirname(__FILE__) + '/../spec_helper'

describe Asset, ".new" do
  before :each do
    @asset = Factory(:asset)
  end

  after :all do
    Asset.delete_all
  end

  describe "Name attribute" do
    it "should be valid with a name" do
      @asset.should be_valid
    end

    it "should have a unique name" do
      Factory.build(:asset, @asset.attributes).should_not be_valid
    end

    it "should be invalid without a name" do
      @asset.name = nil
      @asset.should_not be_valid
    end

    it "should be invalid if the name is longer than 20 characters" do
      @asset.name = 'abcdeabcdeabcdeabcdef'
      @asset.should_not be_valid
    end    
  end
end

describe Asset, ".amount_paid" do
  it "should return the sum of the transaction values" do
    asset = Factory(:asset)
    Factory(:transaction, :asset => asset)
    Factory(:transaction, :asset => asset)
    asset.amount_paid.should eql(200.20)
  end
end