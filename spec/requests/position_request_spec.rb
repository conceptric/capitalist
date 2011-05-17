require 'spec_helper'

describe "Positions" do
  describe "Read" do
    before(:each) do
      @asset = Factory(:asset)
      Factory(:closed_position, :asset => @asset)
      Factory(:open_position, :asset => @asset)
    end
    
    it "displays all the positions for the current asset" do
      visit asset_positions_path(@asset) 
      page.should have_content(@asset.name)
      within('#positions') do
        within(:xpath, './/tr[1]') do
          page.should have_content('Asset')
          page.should have_content('Units')          
          page.should have_content('Status')
        end
        within(:xpath, './/tr[2]') do
          page.should have_content(@asset.name)
          page.should have_content('0')          
          page.should have_content('Closed')          
        end
        within(:xpath, './/tr[3]') do
          page.should have_content(@asset.name)
          page.should have_content('5')          
          page.should have_content('Open')          
        end
      end
    end
           
    it "displays only the positions for the current asset" do
      another_asset = Factory(:asset)
      Factory(:position, :asset => another_asset)
      visit asset_positions_path(@asset) 
      within('#positions') do
        page.should_not have_content(another_asset.name)      
      end
    end
  end
      
  describe "Show" do
    before :each do 
      @position = Factory(:position)
    end

    it "should have a link to the position purchases summary" do
      visit position_path(@position)
      click_link "View position purchases"
      current_path.should eql(position_purchases_path(@position))        
    end

    it "should have a link to the position sales summary" do
      visit position_path(@position)
      click_link "View position sales"
      current_path.should eql(position_sales_path(@position))        
    end

    it "should be possible to return to the asset position summary from show" do
      visit asset_path(@position.asset)
      click_link "Show"
      click_link "View all positions for this asset"      
      current_path.should eql(asset_path(@position.asset))
    end
    
    it "should calculate the capital gain for each selling transaction"
    it "should calculate the remaining number of units"
    it "should calculate the total units sold"
    it "should calculated the total asset capital gain"    
  end

  describe "Create" do
    before :each do 
      @asset = Factory(:asset)      
    end

    it "creates an position with valid input" do
      visit asset_path(@asset)
      click_link "New Position"
      click_button "Create Position" 
      current_path.should eql(position_path(@asset.positions.first))     
      page.should_not have_content("Invalid Field") 
      page.should_not have_content("Asset can't be blank")
      page.should have_content("Successfully created position")
    end
    
    it "should not display an error when no asset is select" do
      visit asset_path(@asset)
      click_link "New Position"
      click_button "Create Position" 
      current_path.should eql(position_path(@asset.positions.first))     
      page.should_not have_content("Invalid Field") 
      page.should_not have_content("Asset can't be blank")
      page.should have_content("Successfully created position")
    end                  
    
    it "should not be able to select an asset" do
      visit asset_path(@asset)
      click_link "New Position"
      within('.position') do
        page.should_not have_selector('position_asset_id')
        page.should_not have_content('Asset')
      end
    end
  end

  describe "Update" do       
    before :each do 
      Factory(:position)
      @asset = Asset.first
    end
    
    it "updates a position with valid input" do
      visit asset_path(@asset)
      click_link "Edit"
      click_button "Update Position" 
      current_path.should eql(position_path(@asset.positions.first))     
      page.should_not have_content("Invalid Field") 
      page.should_not have_content("Asset can't be blank")
      page.should have_content("Successfully updated position")
    end
    
    it "should be possible to return to the asset position summary from edit" do
      visit asset_path(@asset)
      click_link "Edit"
      click_link "Asset Position List"      
      current_path.should eql(asset_path(@asset))
    end
  end

  describe "Delete" do
    it "should delete an existing position" do  
      Factory(:position)
      @asset = Asset.first      
      visit asset_path(@asset)
      click_link "Destroy"
      current_path.should eql(asset_positions_path(@asset))     
      page.should have_content("Successfully destroyed position")
    end
  end                     
end
