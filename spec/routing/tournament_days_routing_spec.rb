require 'spec_helper'

describe TournamentDaysController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/tournament_days" }.should route_to(:controller => "tournament_days", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/tournament_days/new" }.should route_to(:controller => "tournament_days", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/tournament_days/1" }.should route_to(:controller => "tournament_days", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/tournament_days/1/edit" }.should route_to(:controller => "tournament_days", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/tournament_days" }.should route_to(:controller => "tournament_days", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/tournament_days/1" }.should route_to(:controller => "tournament_days", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/tournament_days/1" }.should route_to(:controller => "tournament_days", :action => "destroy", :id => "1") 
    end
  end
end
