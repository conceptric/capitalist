class PurchasesController < ApplicationController
  def index
    @purchases = Purchase.all
  end
  
  def new
    @assets = Asset.all
    @purchase = Purchase.new
  end

  def create
    @purchase = Purchase.new(params[:purchase])
    if @purchase.save
      redirect_to purchases_url, :notice => "Successfully created transaction."
    else
      render :action => 'new'
    end
  end

  def edit
    @purchase = Purchase.find(params[:id])
  end     

  def update
    @purchase = Purchase.find(params[:id])
    if @purchase.update_attributes(params[:purchase])
      redirect_to purchases_url, :notice => "Successfully updated transaction."
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @purchase = Purchase.find(params[:id])
    @purchase.destroy
    redirect_to purchases_url, :notice => "Successfully destroyed transaction."
  end
end
