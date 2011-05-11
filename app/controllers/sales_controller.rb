class SalesController < ApplicationController
  def index
    @sales = Sale.all
  end
  
  def new
    @assets = Asset.all
    @sale = Sale.new
  end

  def create
    @sale = Sale.new(params[:sale])
    if @sale.save
      redirect_to sales_url, :notice => "Successfully created transaction."
    else
      render :action => 'new'
    end
  end

  def edit
    @sale = Sale.find(params[:id])
  end     

  def update
    @sale = Sale.find(params[:id])
    if @sale.update_attributes(params[:sale])
      redirect_to sales_url, :notice => "Successfully updated transaction."
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @sale = Sale.find(params[:id])
    @sale.destroy
    redirect_to sales_url, :notice => "Successfully destroyed transaction."
  end
end
