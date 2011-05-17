require File.dirname(__FILE__) + '/../spec_helper'

describe SalesController do
  before(:each) do                                     
    @position = Factory.build(:position, :id => 1)
    Position.stubs(:find).with(1).returns(@position)                  
  end           
  render_views

  describe "Creating a new sale" do
    it "new action should render new template" do
      get :new, :position_id => 1
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      Sale.any_instance.stubs(:valid?).returns(false)
      post :create, :position_id => 1
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      Sale.any_instance.stubs(:valid?).returns(true)
      post :create, :position_id => 1
      response.should redirect_to(position_sales_url(@position))
    end
  end

  describe "Showing existing sales" do
    it "index action should render index template" do
      get :index, :position_id => 1
      response.should render_template(:index)
    end
  end

  describe "Destroying an existing sale" do
    it "destroy action should destroy model and redirect to index action" do
      Sale.stubs(:find).with(1)
              .returns(Factory.build(:purchase, :position => @position))     
      delete :destroy, :id => 1
      response.should redirect_to(position_sales_url(@position))
    end    
  end
end

describe SalesController, ": Updating" do
  render_views
  
  describe "an existing sale" do   
    before :each do
      @position = Factory(:closed_position) 
      @transaction = @position.sales.first
    end
    
    it "edit action should render edit template" do
      get :edit, :id => @transaction.id
      response.should render_template(:edit)
    end    

    it "update action should render edit template when model is invalid" do
      Sale.any_instance.stubs(:valid?).returns(false)
      put :update, :id => @transaction.id
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      Sale.any_instance.stubs(:valid?).returns(true)
      put :update, :id => @transaction.id
      response.should redirect_to(position_sales_url(@position))
    end
  end  
end