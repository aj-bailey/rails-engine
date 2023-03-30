require "rails_helper"

RSpec.describe "Items Search API" do
  describe "Items Search Index API" do
    it "returns an array of json objects for all items matching name parameter" do

    end

    it "returns an empty array of json objects when there are no matches for any given parameters" do
      
    end

    it "returns all items greater than min price parameter given" do
      
    end

    it "returns all items less than max price parameter given" do
      
    end

    it "returns all items between min and max price parameters given" do
      
    end

    it "returns a 400 error when name and min parameters are given" do
      
    end

    it "returns a 400 error when name and max parameters are given" do
      
    end

    it "returns a 400 error when name, min and max parameters are given" do
      
    end

    it "returns a 400 error when min or max parameters are less than 0" do

    end
  end
end