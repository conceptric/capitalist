class AssetsController < ApplicationController
  def index
    @assets = Asset.all
  end

  def new
    @asset = Asset.new
  end

  def create
    @asset = Asset.new(params[:asset])
    if @asset.save
      redirect_to assets_url, :notice => "Successfully created asset."
    else
      render :action => 'new'
    end
  end
end
