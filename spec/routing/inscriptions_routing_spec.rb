require 'spec_helper'

describe InscriptionsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/inscriptions" }.should route_to(:controller => "inscriptions", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/inscriptions/new" }.should route_to(:controller => "inscriptions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/inscriptions/1" }.should route_to(:controller => "inscriptions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/inscriptions/1/edit" }.should route_to(:controller => "inscriptions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/inscriptions" }.should route_to(:controller => "inscriptions", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/inscriptions/1" }.should route_to(:controller => "inscriptions", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/inscriptions/1" }.should route_to(:controller => "inscriptions", :action => "destroy", :id => "1") 
    end
  end
end
