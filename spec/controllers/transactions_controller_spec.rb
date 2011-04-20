require File.dirname(__FILE__) + '/../spec_helper'

describe TransactionsController do
  before :all do
    Factory(:transaction)
  end
  render_views

  describe "Creating a new transaction" do
    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end

    it "create action should render new template when model is invalid" do
      Transaction.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end

    it "create action should redirect when model is valid" do
      Transaction.any_instance.stubs(:valid?).returns(true)
      post :create
      response.should redirect_to(transactions_url)
    end
  end

  describe "Showing existing transactions" do
    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "Editing an existing transations" do   
    it "edit action should render edit template" do
      transaction = Transaction.first
      get :edit, :id => transaction
      response.should render_template(:edit)
    end    

    it "update action should render edit template when model is invalid" do
      Transaction.any_instance.stubs(:valid?).returns(false)
      put :update, :id => 1
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      Transaction.any_instance.stubs(:valid?).returns(true)
      put :update, :id => 1
      response.should redirect_to(transactions_url)
    end
  end
  
  describe "Destroying an existing transaction" do
    it "destroy action should destroy model and redirect to index action" do
      transaction = Transaction.first
      delete :destroy, :id => transaction
      response.should redirect_to(transactions_url)
      Transaction.exists?(transaction.id).should be_false
    end    
  end
end
     