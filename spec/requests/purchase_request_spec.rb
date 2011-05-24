require 'spec_helper'

describe "Purchases" do    
  before :each do 
    @position = Factory(:open_position)
  end

  describe "Read" do
    it "displays all the purchases for the current position" do
      visit position_purchases_path(@position) 
      page.should have_content(@position.asset.name)
      within('#transactions') do
        within(:xpath, './/tr[1]') do
          page.should have_content('Date')
          page.should have_content('Value')
          page.should have_content('Expenses')      
          page.should have_content('Units')      
          page.should have_content('Unit Price')      
        end
        within(:xpath, './/tr[2]') do
          page.should have_content('1 January 2010')
          page.should have_content('100.10')
          page.should have_content('10.01')      
          page.should have_content('20.02')      
        end
      end   
    end
           
    it "displays only the purchases for the current position" do
      aposition = Factory(:position)
      Factory(:purchase, :position => aposition, :date => Date.new(2010,3,1))
      visit position_purchases_path(@position) 
      page.should_not have_content(aposition.asset.name)
      within('#transactions') do
        page.should_not have_content('1 March 2010')      
      end
    end    
    
    it "should be possible to return to the asset position summary" do
      visit position_purchases_path(@position)
      click_link "Back to the position summary"      
      current_path.should eql(position_path(@position))
    end
  end

  describe "Create" do
    it "creates an purchase with valid input" do
      visit position_purchases_path(@position)
      click_link "New Purchase"
      select('2009', :from => 'purchase[date(1i)]') 
      select('February', :from => 'purchase[date(2i)]') 
      select('14', :from => 'purchase[date(3i)]') 
      fill_in "Units", :with => "125"
      fill_in "Value", :with => "1000.34"
      fill_in "Expenses", :with => "10"
      click_button "Create Purchase" 
      current_path.should eql(position_purchases_path(@position))     
      page.should_not have_content("Invalid Field") 
      page.should_not have_content("Position can't be blank")
      page.should have_content("Successfully created transaction")
      page.should have_content('14 February 2009')
      page.should have_content('125')
      page.should have_content('1,000.34')
      page.should have_content('10')      
    end
  
    it "provides validation warnings with valid input" do
      visit position_purchases_path(@position)
      click_link "New Purchase"
      click_button "Create Purchase"          
      page.should have_content("Invalid Field") 
      page.should_not have_content("Position can't be blank")
      page.should have_content("There are too few units")
    end

    it "creates an purchase with valid input" do
      visit position_purchases_path(@position)
      click_link "New Purchase"
      fill_in "Units", :with => "-1"
      click_button "Create Purchase" 
      page.should have_content("Invalid Field") 
      page.should_not have_content("Position can't be blank")
      page.should have_content("There are too few units")
    end
  end
  
  describe "Update" do
    it "creates an purchase with valid input" do
      visit position_purchases_path(@position)
      click_link "Edit"
      select('2009', :from => 'purchase[date(1i)]') 
      select('February', :from => 'purchase[date(2i)]') 
      select('14', :from => 'purchase[date(3i)]') 
      fill_in "Units", :with => "215"
      fill_in "Value", :with => "1700"
      fill_in "Expenses", :with => "12.50"
      click_button "Update Purchase" 
      current_path.should eql(position_purchases_path(@position))     
      page.should_not have_content("Invalid Field") 
      page.should_not have_content("Position can't be blank")
      page.should have_content("Successfully updated transaction")
      page.should have_content('14 February 2009')
      page.should have_content('215')
      page.should have_content('1,700')
      page.should have_content('12.50')      
    end
  
    it "provides validation warnings with valid input" do
      visit position_purchases_path(@position)
      click_link "Edit"
      fill_in "Units", :with => "0"
      click_button "Update Purchase"          
      page.should have_content("Invalid Field") 
      page.should have_content("There are too few units")
    end

    it "creates an purchase with valid input" do
      visit position_purchases_path(@position)
      click_link "Edit"
      fill_in "Units", :with => "-1"
      click_button "Update Purchase" 
      page.should have_content("Invalid Field") 
      page.should have_content("There are too few units")
    end
  end   
  
  describe "Delete" do
    it "should delete an existing transaction" do  
      visit position_purchases_path(@position)
      click_link "Destroy"
      current_path.should eql(position_purchases_path(@position))     
      page.should_not have_content('1 January 2010')
      page.should_not have_content('100.10')
      page.should_not have_content('10.01')      
    end
  end
end
