class PurchasesController < ApplicationController
  def index
    @transactions = Purchase.all
  end
  
  def new
    @assets = Asset.all
    @transaction = Purchase.new
  end

  def create
    @transaction = Purchase.new(params[:purchase])
    if @transaction.save
      redirect_to purchases_url, :notice => "Successfully created transaction."
    else
      render :action => 'new'
    end
  end

  def edit
    @transaction = Purchase.find(params[:id])
  end     

  def update
    @transaction = Purchase.find(params[:id])
    if @transaction.update_attributes(params[:purchase])
      redirect_to purchases_url, :notice => "Successfully updated transaction."
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @transaction = Purchase.find(params[:id])
    @transaction.destroy
    redirect_to purchases_url, :notice => "Successfully destroyed transaction."
  end
end
