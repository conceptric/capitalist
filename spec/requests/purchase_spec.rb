require 'spec_helper'

describe "Purchases" do    
  before :each do 
    @transaction = Factory(:purchase)
    @asset = Asset.first      
  end

  describe "Read" do
    it "displays all the existing purchases" do
      visit purchases_path
      page.should have_content('1 January 2010')
      page.should have_content(@asset.name)
      page.should have_content('100.10')
      page.should have_content('10.01')      
    end
  end

  describe "Create" do
    it "creates an purchase with valid input" do
      visit purchases_path
      click_link "New Purchase"
      select('2009', :from => 'purchase[date(1i)]') 
      select('February', :from => 'purchase[date(2i)]') 
      select('14', :from => 'purchase[date(3i)]') 
      select(@asset.name, :from => 'purchase_asset_id')       
      fill_in "Units", :with => "125"
      fill_in "Value", :with => "1000.34"
      fill_in "Expenses", :with => "10"
      click_button "Create Purchase" 
      page.should have_content("Successfully created transaction")
      page.should have_content('14 February 2009')
      page.should have_content(@asset.name)
      page.should have_content('125')
      page.should have_content('1,000.34')
      page.should have_content('10')      
    end
  
    it "provides validation warnings with valid input" do
      visit purchases_path
      click_link "New Purchase"
      click_button "Create Purchase"          
      page.should have_content("Invalid Field") 
      page.should have_content("Asset can't be blank")
      page.should have_content("There are too few units")
    end

    it "creates an purchase with valid input" do
      visit purchases_path
      click_link "New Purchase"
      select(@asset.name, :from => 'purchase_asset_id')       
      fill_in "Units", :with => "-1"
      click_button "Create Purchase" 
      page.should have_content("Invalid Field") 
      page.should have_content("There are too few units")
    end
  end
  
  describe "Update" do
    it "creates an purchase with valid input" do
      visit purchases_path
      click_link "Edit"
      select('2009', :from => 'purchase[date(1i)]') 
      select('February', :from => 'purchase[date(2i)]') 
      select('14', :from => 'purchase[date(3i)]') 
      fill_in "Units", :with => "215"
      fill_in "Value", :with => "1700"
      fill_in "Expenses", :with => "12.50"
      click_button "Update Purchase" 
      page.should have_content("Successfully updated transaction")
      page.should have_content('14 February 2009')
      page.should have_content(@asset.name)
      page.should have_content('215')
      page.should have_content('1,700')
      page.should have_content('12.50')      
    end
  
    it "provides validation warnings with valid input" do
      visit purchases_path
      click_link "Edit"
      select('', :from => 'purchase_asset_id')       
      fill_in "Units", :with => "0"
      click_button "Update Purchase"          
      page.should have_content("Invalid Field") 
      page.should have_content("Asset can't be blank")
      page.should have_content("There are too few units")
    end

    it "creates an purchase with valid input" do
      visit purchases_path
      click_link "Edit"
      fill_in "Units", :with => "-1"
      click_button "Update Purchase" 
      page.should have_content("Invalid Field") 
      page.should have_content("There are too few units")
    end
  end   
  
  describe "Delete" do
    it "should delete an existing transaction" do  
      visit purchases_path
      click_link "Destroy"
      page.should_not have_content('1 January 2010')
      page.should_not have_content(@asset.name)
      page.should_not have_content('100.10')
      page.should_not have_content('10.01')      
    end
  end
end
