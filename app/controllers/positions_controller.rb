class PositionsController < ApplicationController
  def index
    @asset = Asset.find(params[:asset_id])    
    @positions = @asset.positions
  end

  def show
    @position = Position.find(params[:id])
  end

  def new
    @asset = Asset.find(params[:asset_id])    
    @position = @asset.positions.build
  end

  def create
    @asset = Asset.find(params[:asset_id])    
    @position = Position.new(params[:position])
    if @position.save
      redirect_to position_path(@position), 
        :notice => "Successfully created position."
    else
      render :action => 'new'
    end
  end

  def edit
    @position = Position.find(params[:id]) 
  end

  def update
    @position = Position.find(params[:id])
    if @position.update_attributes(params[:position])
      redirect_to position_path(@position), 
        :notice  => "Successfully updated position."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @position = Position.find(params[:id])
    asset = @position.asset
    @position.destroy
    redirect_to asset_positions_url(asset), 
      :notice => "Successfully destroyed position."
  end
end
