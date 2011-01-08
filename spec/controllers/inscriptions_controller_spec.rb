require 'spec_helper'

describe InscriptionsController do

  def mock_inscription(stubs={})
    @mock_inscription ||= mock_model(Inscription, stubs)
  end

  describe "GET index" do
    it "assigns all inscriptions as @inscriptions" do
      Inscription.stub!(:find).with(:all).and_return([mock_inscription])
      get :index
      assigns[:inscriptions].should == [mock_inscription]
    end
  end

  describe "GET show" do
    it "assigns the requested inscription as @inscription" do
      Inscription.stub!(:find).with("37").and_return(mock_inscription)
      get :show, :id => "37"
      assigns[:inscription].should equal(mock_inscription)
    end
  end

  describe "GET new" do
    it "assigns a new inscription as @inscription" do
      Inscription.stub!(:new).and_return(mock_inscription)
      get :new
      assigns[:inscription].should equal(mock_inscription)
    end
  end

  describe "GET edit" do
    it "assigns the requested inscription as @inscription" do
      Inscription.stub!(:find).with("37").and_return(mock_inscription)
      get :edit, :id => "37"
      assigns[:inscription].should equal(mock_inscription)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created inscription as @inscription" do
        Inscription.stub!(:new).with({'these' => 'params'}).and_return(mock_inscription(:save => true))
        post :create, :inscription => {:these => 'params'}
        assigns[:inscription].should equal(mock_inscription)
      end

      it "redirects to the created inscription" do
        Inscription.stub!(:new).and_return(mock_inscription(:save => true))
        post :create, :inscription => {}
        response.should redirect_to(inscription_url(mock_inscription))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved inscription as @inscription" do
        Inscription.stub!(:new).with({'these' => 'params'}).and_return(mock_inscription(:save => false))
        post :create, :inscription => {:these => 'params'}
        assigns[:inscription].should equal(mock_inscription)
      end

      it "re-renders the 'new' template" do
        Inscription.stub!(:new).and_return(mock_inscription(:save => false))
        post :create, :inscription => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested inscription" do
        Inscription.should_receive(:find).with("37").and_return(mock_inscription)
        mock_inscription.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :inscription => {:these => 'params'}
      end

      it "assigns the requested inscription as @inscription" do
        Inscription.stub!(:find).and_return(mock_inscription(:update_attributes => true))
        put :update, :id => "1"
        assigns[:inscription].should equal(mock_inscription)
      end

      it "redirects to the inscription" do
        Inscription.stub!(:find).and_return(mock_inscription(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(inscription_url(mock_inscription))
      end
    end

    describe "with invalid params" do
      it "updates the requested inscription" do
        Inscription.should_receive(:find).with("37").and_return(mock_inscription)
        mock_inscription.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :inscription => {:these => 'params'}
      end

      it "assigns the inscription as @inscription" do
        Inscription.stub!(:find).and_return(mock_inscription(:update_attributes => false))
        put :update, :id => "1"
        assigns[:inscription].should equal(mock_inscription)
      end

      it "re-renders the 'edit' template" do
        Inscription.stub!(:find).and_return(mock_inscription(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested inscription" do
      Inscription.should_receive(:find).with("37").and_return(mock_inscription)
      mock_inscription.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the inscriptions list" do
      Inscription.stub!(:find).and_return(mock_inscription(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(inscriptions_url)
    end
  end

end
