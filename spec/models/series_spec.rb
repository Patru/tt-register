require 'spec_helper'

describe Series do
  fixtures :players, :series
  
  context "when matching sex" do
    it "should accept women in female series" do
      damen_a = series(:wa20)
      damen_a.matches_sex?(players(:sandra)).should be_true
    end
    
    it "should reject men in female series" do
      damen_a = series(:wa20)
      damen_a.matches_sex?(players(:paul)).should be_false
    end
    
    it "should accept men in male series" do
      series(:ma20).matches_sex?(players(:paul)).should be_true
    end
    
    it "should reject women in male series" do
      series(:ma20).matches_sex?(players(:sandra)).should be_false
    end
    
    it "should accept men and women in unspecified series" do
      mb12 = series(:mb12)
      mb12.matches_sex?(players(:sandra)).should be_true
      mb12.matches_sex?(players(:paul)).should be_true
    end
  end
  
  context "when matching ranking" do
    it "should use the woman_ranking in women series" do
      series(:wb12).matches_ranking_of?(players(:anke)).should be_false
      wa20 = series(:wa20)
      wa20.matches_ranking_of?(players(:anke)).should be_true
      wa20.matches_ranking_of?(players(:paul)).should be_false
    end
    
    it "should use the regular ranking in men and unspecified series" do
      mb12 = series(:mb12)
      mb12.matches_ranking_of?(players(:anke)).should be_true
      mb12.matches_ranking_of?(players(:sandra)).should be_false
      mb12.matches_ranking_of?(players(:paul)).should be_true
      mb12.matches_ranking_of?(players(:tobias)).should be_false
      series(:wa20).matches_ranking_of?(players(:tobias)).should be_false
      series(:ma20).matches_ranking_of?(players(:tobias)).should be_true
    end
  end
  
  context "when matching players" do
    it "should allow women to play in women series where ranking is ok" do
      series(:wa20).may_be_played_by?(players(:sandra)).should be_true
    end
    
    it "should reject women in women series where ranking is not ok" do
      series(:wb12).may_be_played_by?(players(:sandra)).should be_false
    end
    
    it "should reject men in women series where ranking is ok" do
      wb12 = series(:wb12)
      wb12.matches_ranking?(players(:paul).ranking).should be_true
      wb12.may_be_played_by?(players(:paul)).should be_false
    end
    
    it "should reject women in men series where ranking is ok" do
      ma20 = series(:ma20)
      ma20.matches_ranking_of?(players(:sandra)).should be_true
      ma20.may_be_played_by?(players(:sandra)).should be_false
    end
  end
end
