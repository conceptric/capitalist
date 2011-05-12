require 'spec_helper'

describe "Assets" do    
  describe "Read" do
    it "displays all the existing assets" do
      Factory(:asset, :name => 'AssetName')
      visit assets_path
      page.should have_content('AssetName')
    end
  end

  describe "Create" do
    it "creates an asset with valid input" do
      visit assets_path
      click_link "New Asset"
      fill_in "Name", :with => "NewAsset"
      fill_in "Description", :with => "This is a new Asset"
      click_button "Create Asset"
      page.should have_content("Successfully created asset")
      page.should have_content("NewAsset")
      page.should have_content("This is a new Asset")
    end

    it "provides a validation warning about Name" do
      visit assets_path
      click_link "New Asset"
      fill_in "Name", :with => ""
      fill_in "Description", :with => "This is a new Asset"
      click_button "Create Asset"
      page.should have_content("Invalid Field")
      page.should have_content("Name can't be blank")
    end
  end

  describe "Update" do
    before :each do 
      @asset = Factory(:asset)
    end

    it "updates an asset with valid input" do
      visit assets_path
      click_link "Edit"
      fill_in "Name", :with => "EditedAsset"
      fill_in "Description", :with => "Modified description"
      click_button "Update Asset"
      page.should have_content("Successfully updated asset")
      page.should have_content("EditedAsset")
      page.should have_content("Modified description")
    end

    it "provides a validation warning about Name" do
      visit assets_path
      click_link "Edit"
      fill_in "Name", :with => ""
      click_button "Update Asset"
      page.should have_content("Invalid Field")
      page.should have_content("Name can't be blank")
    end
  end   

  describe "Delete" do
    before :each do 
      @asset = Factory(:asset)
    end

    it "should delete an existing asset" do  
      visit assets_path
      click_link "Destroy"
      page.should_not have_content(@asset.name)
    end
  end   

  describe "Show" do   
    before(:each) do
      @asset = Factory(:asset)
      Factory(:purchase, :asset => @asset)      
      Factory(:purchase, :date => Date.new(2011,3,1), :asset => @asset)      
      Factory(:sale, :asset => @asset)
    end         
    
    it "should show me a list of transactions for the asset order by date" do
      visit assets_path
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

    it "should calculate the value of assets bought" do
      Factory(:purchase, :asset => @asset)
      visit assets_path
      click_link "Show"
      within('#position') do
        within('#amount_paid') do
          page.should have_content('300.30')
        end
      end      
    end

    it "should calculate the total number of units bought" do
      Factory(:purchase, :asset => @asset)
      visit assets_path
      click_link "Show"
      within('#position') do
        within('#units_held') do
          page.should have_content('10')
        end
      end      
    end
      
    it "should calculate the averaged buying price" do
      Factory(:purchase, :asset => @asset)
      visit assets_path
      click_link "Show"
      within('#position') do
        within('#unit_price') do
          page.should have_content('20.02')
        end
      end      
    end

    it "should calculate the capital gain for each selling transaction"
    it "should calculate the remaining number of units"

    it "should calculate the total units sold"
    it "should calculated the total asset capital gain"
  end
end
