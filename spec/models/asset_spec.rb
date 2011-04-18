require File.dirname(__FILE__) + '/../spec_helper'

describe Asset, ".new" do
  before :each do
    @asset = Factory(:asset)
  end
  
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
