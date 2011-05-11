require File.dirname(__FILE__) + '/../spec_helper'

describe SalesController do
  render_views

  describe "Creating a new sale" do
    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      Sale.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      Sale.any_instance.stubs(:valid?).returns(true)
      post :create
      response.should redirect_to(sales_url)
    end
  end

  describe "Showing existing sales" do
    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "Editing an existing sales" do   
    before :each do
      Sale.stubs(:find).with(1).returns(Factory.build(:sale))      
    end
    
    it "edit action should render edit template" do
      get :edit, :id => 1
      response.should render_template(:edit)
    end    

    it "update action should render edit template when model is invalid" do
      Sale.any_instance.stubs(:valid?).returns(false)
      put :update, :id => 1
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      Sale.any_instance.stubs(:valid?).returns(true)
      put :update, :id => 1
      response.should redirect_to(sales_url)
    end
  end
  
  describe "Destroying an existing sale" do
    it "destroy action should destroy model and redirect to index action" do
      Sale.stubs(:find).with(1).returns(Factory.build(:sale))      
      delete :destroy, :id => 1
      response.should redirect_to(sales_url)
      Sale.exists?(1).should be_false
    end    
  end
end
