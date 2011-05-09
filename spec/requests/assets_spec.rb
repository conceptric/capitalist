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
    it "should show me a list of all the transactions for the asset" do
      asset = Factory(:asset)
      visit assets_path
      click_link "Show"
      page.should have_content(asset.name)
    end
  end
end
