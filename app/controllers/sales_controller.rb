class SalesController < ApplicationController
  def index
    @transactions = Sale.all
  end
  
  def new
    @assets = Asset.all
    @transaction = Sale.new
  end

  def create
    @transaction = Sale.new(params[:sale])
    if @transaction.save
      redirect_to sales_url, :notice => "Successfully created transaction."
    else
      render :action => 'new'
    end
  end

  def edit
    @transaction = Sale.find(params[:id])
  end     

  def update
    @transaction = Sale.find(params[:id])
    if @transaction.update_attributes(params[:sale])
      redirect_to sales_url, :notice => "Successfully updated transaction."
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @transaction = Sale.find(params[:id])
    @transaction.destroy
    redirect_to sales_url, :notice => "Successfully destroyed transaction."
  end
end
