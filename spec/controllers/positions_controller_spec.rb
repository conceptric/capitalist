require File.dirname(__FILE__) + '/../spec_helper'

describe PositionsController do
  before(:each) do
    @position = Factory.build(:position, :id => 1)
    @asset = @position.asset
  end
  render_views

  describe "Creating a new position" do
    it "new action should render new template" do
      get :new, :asset_id => @asset.id
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      Position.any_instance.stubs(:valid?).returns(false)
      post :create, :asset_id => @asset.id
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      Position.stubs(:find).with(1).returns(@position)      
      Position.any_instance.stubs(:valid?).returns(true) 
      post :create, :asset_id => @asset.id
      response.should redirect_to(position_path(@position))
    end
  end

  describe "Showing existing positions" do
    it "index action should render index template" do
      get :index, :asset_id => @asset.id
      response.should render_template(:index)
    end
  end

  describe "Editing an existing positions" do   
    before :each do 
      @position = Factory(:position)
    end
    
    it "edit action should render edit template" do
      get :edit, :id => @position.id
      response.should render_template(:edit)
    end    

    it "update action should render edit template when model is invalid" do
      Position.any_instance.stubs(:valid?).returns(false)
      put :update, :id => @position.id
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      Position.any_instance.stubs(:valid?).returns(true)
      put :update, :id => @position.id
      response.should redirect_to(position_path(@position))
    end
  end
  
  describe "Destroying an existing position" do
    it "destroy action should destroy model and redirect to index action" do
      Position.stubs(:find).with(1).returns(@position)      
      delete :destroy, :id => 1
      response.should redirect_to(asset_positions_url(@asset))
      Position.exists?(1).should be_false
    end    
  end
end
