require 'spec_helper'

describe InscriptionPlayersController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/inscription_players" }.should route_to(:controller => "inscription_players", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/inscription_players/new" }.should route_to(:controller => "inscription_players", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/inscription_players/1" }.should route_to(:controller => "inscription_players", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/inscription_players/1/edit" }.should route_to(:controller => "inscription_players", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/inscription_players" }.should route_to(:controller => "inscription_players", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/inscription_players/1" }.should route_to(:controller => "inscription_players", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/inscription_players/1" }.should route_to(:controller => "inscription_players", :action => "destroy", :id => "1") 
    end
  end
end
