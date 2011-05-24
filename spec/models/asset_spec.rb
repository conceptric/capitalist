require File.dirname(__FILE__) + '/../spec_helper'

describe Asset, ".new" do
  before :each do
    @asset = Factory(:asset)
  end

  describe "Name attribute" do
    it "is a string" do
      @asset.should be_valid
    end

    it "is unique" do
      Factory.build(:asset, @asset.attributes).should_not be_valid
    end

    it "cannot be nil" do
      @asset.name = nil
      @asset.should_not be_valid
    end

    it "cannot be longer than 20 characters" do
      @asset.name = 'abcdeabcdeabcdeabcdef'
      @asset.should_not be_valid
    end    
  end

  describe "Positions attribute" do
    it "is allowed to be empty" do
      @asset.positions.should be_empty
    end                        
    
    it "is associated with Positions" do
      asset = Factory(:asset_with_position)
      asset.positions.size.should eql(1)
      asset.positions.first.should be_instance_of(Position)
    end

    it "cascades deletion to associated Positions" do
      asset = Factory(:asset_with_position)
      Position.all.size.should eql(1)
      asset.destroy                 
      Asset.exists?(asset.id).should be_false
      Position.all.size.should eql(0)
    end
  end
end

describe Asset, ".current_units" do
  before(:each) do
    Position.any_instance.stubs(:current_units).returns(5)    
    @asset = Factory(:asset)
  end

  it "is zero when there are no positions" do
    @asset.current_units.should eql(0)    
  end

  it "is the units held in a single position" do    
    Factory(:position, :asset => @asset)
    @asset.current_units.should eql(5)
  end

  it "is the sum of the units held in two positions" do
    Factory(:position, :asset => @asset)
    Factory(:position, :asset => @asset)
    @asset.current_units.should eql(10)
  end
end
