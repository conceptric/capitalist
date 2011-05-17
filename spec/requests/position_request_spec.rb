require 'spec_helper'

describe "Positions" do
  describe "Show" do
    before :each do 
      @asset = Factory(:asset)
      @position = Factory(:position, :asset => @asset)
      Factory(:purchase, :position => @position)      
      Factory(:purchase, :position => @position, :date => Date.new(2011,3,1))      
      Factory(:sale, :position => @position)
    end

    it "should show me a list of position transactions order by date" do
      visit asset_path(@asset)
      click_link "Show"
      page.should have_content(@asset.name) 
      within('#transactions') do
        within(:xpath, './/tr[2]') do
          page.should have_content('1 January 2010')
          page.should have_content('5')
          page.should have_content('100.10')
          page.should have_content('Purchase')
        end
        within(:xpath, './/tr[3]') do
          page.should have_content('1 January 2011')
          page.should have_content('5')
          page.should have_content('200.10')
          page.should have_content('Sale')
        end
        within(:xpath, './/tr[4]') do
          page.should have_content('1 March 2011')
          page.should have_content('5')
          page.should have_content('100.10')
          page.should have_content('Purchase')
        end
      end
    end

    it "should have a link to add a purchase in show" do
      visit position_path(@position)
      click_link "Add a new Purchase"
      current_path.should eql(new_position_purchase_path(@position))        
    end

    it "should have a link to add a sale in show" do
      visit position_path(@position)
      click_link "Add a new Sale"
      current_path.should eql(new_position_sale_path(@position))        
    end

    it "should be possible to return to the asset position summary from show" do
      visit asset_path(@asset)
      click_link "Show"
      click_link "Asset Position List"      
      current_path.should eql(asset_path(@asset))
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
