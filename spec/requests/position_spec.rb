require 'spec_helper'

describe "Positions" do    
  before :each do 
    @position = Factory(:position)
    @asset = Asset.first      
  end

  describe "Read" do
    it "displays all the existing positions" do
      visit positions_path
      page.should have_content(@asset.name)
    end
  end

  describe "Create" do
    it "creates an position with valid input" do
      visit positions_path
      click_link "New Position"
      select(@asset.name, :from => 'position_asset_id')       
      click_button "Create Position" 
      page.should have_content("Successfully created position")
      page.should have_content(@asset.name)
    end
    
    it "should display an error when no asset is select" do
      visit positions_path
      click_link "New Position"
      click_button "Create Position" 
      page.should have_content("Invalid Field") 
      page.should have_content("Asset can't be blank")
    end
  end

  describe "Update" do
    it "updates an position with valid input" do
      Factory(:asset, :name => 'TEST')
      visit positions_path
      click_link "Edit"
      select('TEST', :from => 'position_asset_id')       
      click_button "Update Position" 
      page.should have_content("Successfully updated position")
      page.should have_content('TEST')
    end
    
    it "should display an error when no asset is select" do
      visit positions_path
      click_link "Edit"
      select('', :from => 'position_asset_id')       
      click_button "Update Position" 
      page.should have_content("Invalid Field") 
      page.should have_content("Asset can't be blank")
    end
  end

  describe "Delete" do
    it "should delete an existing position" do  
      visit positions_path
      click_link "Destroy"
      page.should_not have_content(@asset.name)
    end
  end
end
