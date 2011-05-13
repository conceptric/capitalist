require File.dirname(__FILE__) + '/../spec_helper'

describe Position do
  before(:each) do
    @position = Factory.build(:position)
  end

  it "should be valid" do
    @position.should be_valid
  end

  describe "Asset attribute" do
    it "should be associated to an Asset" do
      @position.asset.should be_instance_of(Asset)
    end

    it "should not allow the associated Asset to be nil" do
      @position.asset = nil
      @position.should_not be_valid
    end                                                            
  end
end

