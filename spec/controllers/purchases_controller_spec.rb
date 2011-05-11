require File.dirname(__FILE__) + '/../spec_helper'

describe PurchasesController do
  render_views

  describe "Creating a new purchase" do
    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      Purchase.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      Purchase.any_instance.stubs(:valid?).returns(true)
      post :create
      response.should redirect_to(purchases_url)
    end
  end

  describe "Showing existing purchases" do
    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "Editing an existing purchases" do   
    before :each do
      Purchase.stubs(:find).with(1).returns(Factory.build(:purchase))      
    end
    
    it "edit action should render edit template" do
      get :edit, :id => 1
      response.should render_template(:edit)
    end    

    it "update action should render edit template when model is invalid" do
      Purchase.any_instance.stubs(:valid?).returns(false)
      put :update, :id => 1
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      Purchase.any_instance.stubs(:valid?).returns(true)
      put :update, :id => 1
      response.should redirect_to(purchases_url)
    end
  end
  
  describe "Destroying an existing purchase" do
    it "destroy action should destroy model and redirect to index action" do
      Purchase.stubs(:find).with(1).returns(Factory.build(:purchase))      
      delete :destroy, :id => 1
      response.should redirect_to(purchases_url)
      Purchase.exists?(1).should be_false
    end    
  end
end
     