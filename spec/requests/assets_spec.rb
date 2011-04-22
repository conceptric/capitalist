require 'spec_helper'

describe "Assets" do
  describe "GET /assets" do
    it "displays all the assets" do
      factory = Factory(:asset)
      get assets_path
      response.status.should be(200)
      response.body.should include(factory.name)
    end
  end
end
