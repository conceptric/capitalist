require 'spec_helper'

describe "Transactions" do    
  before :each do 
    @transaction = Factory(:transaction)
    @asset = Asset.first      
  end

  describe "Read" do
    it "displays all the existing transactions" do
      visit transactions_path
      page.should have_content('1 January 2010')
      page.should have_content(@asset.name)
      page.should have_content('100.10')
      page.should have_content('10.01')      
    end
  end

  describe "Create" do
    it "creates an transaction with valid input" do
      visit transactions_path
      click_link "New Transaction"
      select('2009', :from => 'transaction_date_1i') 
      select('February', :from => 'transaction_date_2i') 
      select('14', :from => 'transaction_date_3i') 
      select(@asset.name, :from => 'transaction_asset_id')       
      fill_in "Units", :with => "125"
      fill_in "Total value", :with => "1000.34"
      fill_in "Cost", :with => "10"
      click_button "Create Transaction" 
      page.should have_content("Successfully created transaction")
      page.should have_content('14 February 2009')
      page.should have_content(@asset.name)
      page.should have_content('125')
      page.should have_content('1,000.34')
      page.should have_content('10')      
    end
  
    it "provides validation warnings with valid input" do
      visit transactions_path
      click_link "New Transaction"
      click_button "Create Transaction"          
      page.should have_content("Invalid Field") 
      page.should have_content("Asset can't be blank")
      page.should have_content("There are too few units")
    end

    it "creates an transaction with valid input" do
      visit transactions_path
      click_link "New Transaction"
      select(@asset.name, :from => 'transaction_asset_id')       
      fill_in "Units", :with => "-1"
      click_button "Create Transaction" 
      page.should have_content("Invalid Field") 
      page.should have_content("There are too few units")
    end
  end
  
  describe "Update" do
    it "creates an transaction with valid input" do
      visit transactions_path
      click_link "Edit"
      select('2009', :from => 'transaction_date_1i') 
      select('February', :from => 'transaction_date_2i') 
      select('14', :from => 'transaction_date_3i') 
      fill_in "Units", :with => "215"
      fill_in "Total value", :with => "1700"
      fill_in "Cost", :with => "12.50"
      click_button "Update Transaction" 
      page.should have_content("Successfully updated transaction")
      page.should have_content('14 February 2009')
      page.should have_content(@asset.name)
      page.should have_content('215')
      page.should have_content('1,700')
      page.should have_content('12.50')      
    end
  
    it "provides validation warnings with valid input" do
      visit transactions_path
      click_link "Edit"
      select('', :from => 'transaction_asset_id')       
      fill_in "Units", :with => "0"
      click_button "Update Transaction"          
      page.should have_content("Invalid Field") 
      page.should have_content("Asset can't be blank")
      page.should have_content("There are too few units")
    end

    it "creates an transaction with valid input" do
      visit transactions_path
      click_link "Edit"
      fill_in "Units", :with => "-1"
      click_button "Update Transaction" 
      page.should have_content("Invalid Field") 
      page.should have_content("There are too few units")
    end
  end   
  
  describe "Delete" do
    it "should delete an existing transaction" do  
      visit transactions_path
      click_link "Destroy"
      page.should_not have_content('1 January 2010')
      page.should_not have_content(@asset.name)
      page.should_not have_content('100.10')
      page.should_not have_content('10.01')      
    end
  end
end
