require 'spec_helper'

describe "Assets" do
  describe "GET /assets" do
    it "displays all the existing assets" do
      factory = Factory(:asset)
      visit assets_path
      page.should have_content(factory.name)
    end
  end

  describe "POST /assets" do
    it "creates an asset with valid input" do
      visit new_asset_path
      fill_in "Name", :with => "NewAsset"
      fill_in "Description", :with => "This is a new Asset"
      click_button "Create Asset"
      page.should have_content("Successfully created asset")
      page.should have_content("New Asset")
      page.should have_content("This is a new Asset")
    end

    it "provides a validation warning about Name" do
      visit new_asset_path
      fill_in "Name", :with => ""
      fill_in "Description", :with => "This is a new Asset"
      click_button "Create Asset"
      page.should have_content("Invalid Field")
      page.should have_content("Name can't be blank")
    end
  end
end
