class SalesController < ApplicationController
  def index
    @transactions = Sale.all
  end
  
  def new
    @position = Position.find(params[:position_id])
    @assets = Asset.all
    @transaction = Sale.new
  end

  def create
    @position = Position.find(params[:position_id])
    @transaction = Sale.new(params[:sale])
    if @transaction.save
      redirect_to position_sales_url(@position), 
        :notice => "Successfully created transaction."
    else
      render :action => 'new'
    end
  end

  def edit
    @transaction = Sale.find(params[:id])
    @position_for_route = @transaction.position
  end     

  def update
    @transaction = Sale.find(params[:id])
    @position_for_route = @transaction.position
    if @transaction.update_attributes(params[:sale])
      redirect_to position_sales_url(@transaction.position), 
        :notice => "Successfully updated transaction."
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @transaction = Sale.find(params[:id])
    position = @transaction.position
    @transaction.destroy
    redirect_to position_sales_url(position), 
      :notice => "Successfully destroyed transaction."
  end
end
