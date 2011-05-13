require 'spec_helper'

describe "Positions" do    
  describe "Show" do
    before :each do 
      @asset = Factory(:asset)
      @position = Factory(:position, :asset => @asset)
      Factory(:purchase, :asset => @asset, :position => @position)      
      Factory(:purchase, :date => Date.new(2011,3,1), 
              :asset => @asset, :position => @position)      
      Factory(:sale, :asset => @asset, :position => @position)
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
  end

  describe "Create" do
    before :each do 
      @asset = Factory(:asset)      
    end

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
    before :each do 
      Factory(:position)
    end
    
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
      Factory(:position)
      @asset = Asset.first      
      visit positions_path
      click_link "Destroy"
      page.should_not have_content(@asset.name)
    end
  end  
end
