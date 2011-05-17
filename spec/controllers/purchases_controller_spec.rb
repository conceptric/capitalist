require File.dirname(__FILE__) + '/../spec_helper'

describe PurchasesController do
  before(:each) do                                     
    @position = Factory.build(:position, :id => 1)
    Position.stubs(:find).with(1).returns(@position)                  
  end           
  render_views

  describe "Creating a new purchase" do                            
    it "new action should render new template" do          
      get :new, :position_id => 1
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      Purchase.any_instance.stubs(:valid?).returns(false)
      post :create, :position_id => 1
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      Purchase.any_instance.stubs(:valid?).returns(true)
      post :create, :position_id => 1
      response.should redirect_to(position_purchases_url(@position))
    end
  end

  describe "Showing existing purchases" do
    it "index action should render index template" do
      get :index, :position_id => 1
      response.should render_template(:index)
    end
  end

  describe "Destroying an existing purchase" do
    it "destroy action should destroy model and redirect to index action" do
      Purchase.stubs(:find).with(1)
              .returns(Factory.build(:purchase, :position => @position))
      delete :destroy, :id => 1
      response.should redirect_to(position_purchases_url(@position))
    end    
  end
end

describe PurchasesController, ": Updating" do
  render_views
  
  describe "Editing an existing purchases" do   
    before :each do
      @transaction = Factory(:purchase) 
      @position = @transaction.position
    end
    
    it "edit action should render edit template" do
      get :edit, :id => @transaction.id
      response.should render_template(:edit)
    end    

    it "update action should render edit template when model is invalid" do
      Purchase.any_instance.stubs(:valid?).returns(false)
      put :update, :id => @transaction.id
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      Purchase.any_instance.stubs(:valid?).returns(true)
      put :update, :id => @transaction.id
      response.should redirect_to(position_purchases_url(@position))
    end
  end  
end