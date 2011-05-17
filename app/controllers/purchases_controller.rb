class PurchasesController < ApplicationController
  def index
    @position = Position.find(params[:position_id])
    @transactions = @position.purchases
  end
  
  def new
    @position = Position.find(params[:position_id])
    @transaction = @position.purchases.build
  end

  def create
    @position = Position.find(params[:position_id])
    @transaction = Purchase.new(params[:purchase])
    if @transaction.save
      redirect_to position_purchases_url(@position), 
        :notice => "Successfully created transaction."
    else
      render :action => 'new'
    end
  end

  def edit
    @transaction = Purchase.find(params[:id])
    @position_for_route = @transaction.position
  end     

  def update
    @transaction = Purchase.find(params[:id])
    @position_for_route = @transaction.position
    if @transaction.update_attributes(params[:purchase])
      redirect_to position_purchases_url(@transaction.position), 
        :notice => "Successfully updated transaction."
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @transaction = Purchase.find(params[:id])
    position = @transaction.position
    @transaction.destroy
    redirect_to position_purchases_url(position), 
      :notice => "Successfully destroyed transaction."
  end
end
