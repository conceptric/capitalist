require File.dirname(__FILE__) + '/../spec_helper'

describe AssetsController do    
  render_views

  describe "Creating a new asset" do
    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      Asset.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      Asset.any_instance.stubs(:valid?).returns(true)
      post :create
      response.should redirect_to(assets_url)
    end
  end

  describe "Showing existing assets" do
    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end

    it "show action should render show template" do
      Asset.stubs(:find).with(1).returns(Factory.build(:asset))      
      get :show, :id => 1
      response.should render_template(:show)
    end
  end

  describe "Editing an existing assets" do          
    before :each do
      Asset.stubs(:find).with(1).returns(Factory.build(:asset))      
    end
    
    it "edit action should render edit template" do
      get :edit, :id => 1
      response.should render_template(:edit)
    end    

    it "update action should render edit template when model is invalid" do
      Asset.any_instance.stubs(:valid?).returns(false)
      put :update, :id => 1
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      Asset.any_instance.stubs(:valid?).returns(true)
      put :update, :id => 1
      response.should redirect_to(assets_url)
    end
  end
  
  describe "Destroying an existing asset" do
    it "destroy action should destroy model and redirect to index action" do
      Asset.stubs(:find).with(1).returns(Factory.build(:asset))      
      delete :destroy, :id => 1
      response.should redirect_to(assets_url)
      Asset.exists?(1).should be_false
    end    
  end
end
