require 'spec_helper'
describe Player do
  fixtures :players

  before(:each) do
    @valid_attributes = {
      :licence => 701726,
      :name => "Trunz",
      :first_name => "Paul",
      :club => "Young Stars ZH",
      :ranking => 3,
      :woman_ranking => nil,
      :category => "O40",
    }
  end

  it "should create a new instance given valid attributes" do
    patru = Player.create!(@valid_attributes)
    patru.should be_valid
    patru.woman_ranking.should be_nil
    patru.should be_male
    patru.should be_matches_category("O40")
    patru.should_not be_matches_category("O50")
    patru.should_not be_matches_category("U13")
  end
  
  it "should not be male if it has a woman ranking" do
    sandra = players(:sandra)
    sandra.should_not be_male
  end

  context "when matching categories" do
    it "should not allow O-Series for U-Players" do
      pascal = players(:pascal)
      pascal.should be_male
      pascal.should_not be_matches_category("O40")
      pascal.should_not be_matches_category("O50")
      pascal.should be_matches_category("Elite")
    end
    
    it "should match higer U-Categories and not match lower ones" do
      pascal = players(:pascal)
  
      pascal.should be_matches_category("U21")
      pascal.should be_matches_category("U15")
      pascal.should be_matches_category("Elite")
      pascal.should_not be_matches_category("U13")
    end
    
    it "should match O40-categories for O50 and older players" do
      otto = players(:otto)
      otto.matches_category?("O40").should be_true
      otto.matches_category?("Elite").should be_true
      otto.matches_category?("U13").should be_false
    end
    
    it "should match all U-categories for U11 players" do
      pekka = players(:four)
      pekka.matches_category?("U21").should be_true
      pekka.matches_category?("U13").should be_true
    end
  end
end