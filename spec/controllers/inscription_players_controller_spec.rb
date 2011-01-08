require 'spec_helper'

describe InscriptionPlayersController do

  def mock_inscription_player(stubs={})
    @mock_inscription_player ||= mock_model(InscriptionPlayer, stubs)
  end

  describe "GET index" do
    it "assigns all inscription_players as @inscription_players" do
      InscriptionPlayer.stub!(:find).with(:all).and_return([mock_inscription_player])
      get :index
      assigns[:inscription_players].should == [mock_inscription_player]
    end
  end

  describe "GET show" do
    it "assigns the requested inscription_player as @inscription_player" do
      InscriptionPlayer.stub!(:find).with("37").and_return(mock_inscription_player)
      get :show, :id => "37"
      assigns[:inscription_player].should equal(mock_inscription_player)
    end
  end

  describe "GET new" do
    it "assigns a new inscription_player as @inscription_player" do
      InscriptionPlayer.stub!(:new).and_return(mock_inscription_player)
      get :new
      assigns[:inscription_player].should equal(mock_inscription_player)
    end
  end

  describe "GET edit" do
    it "assigns the requested inscription_player as @inscription_player" do
      InscriptionPlayer.stub!(:find).with("37").and_return(mock_inscription_player)
      get :edit, :id => "37"
      assigns[:inscription_player].should equal(mock_inscription_player)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created inscription_player as @inscription_player" do
        InscriptionPlayer.stub!(:new).with({'these' => 'params'}).and_return(mock_inscription_player(:save => true))
        post :create, :inscription_player => {:these => 'params'}
        assigns[:inscription_player].should equal(mock_inscription_player)
      end

      it "redirects to the created inscription_player" do
        InscriptionPlayer.stub!(:new).and_return(mock_inscription_player(:save => true))
        post :create, :inscription_player => {}
        response.should redirect_to(inscription_player_url(mock_inscription_player))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved inscription_player as @inscription_player" do
        InscriptionPlayer.stub!(:new).with({'these' => 'params'}).and_return(mock_inscription_player(:save => false))
        post :create, :inscription_player => {:these => 'params'}
        assigns[:inscription_player].should equal(mock_inscription_player)
      end

      it "re-renders the 'new' template" do
        InscriptionPlayer.stub!(:new).and_return(mock_inscription_player(:save => false))
        post :create, :inscription_player => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested inscription_player" do
        InscriptionPlayer.should_receive(:find).with("37").and_return(mock_inscription_player)
        mock_inscription_player.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :inscription_player => {:these => 'params'}
      end

      it "assigns the requested inscription_player as @inscription_player" do
        InscriptionPlayer.stub!(:find).and_return(mock_inscription_player(:update_attributes => true))
        put :update, :id => "1"
        assigns[:inscription_player].should equal(mock_inscription_player)
      end

      it "redirects to the inscription_player" do
        InscriptionPlayer.stub!(:find).and_return(mock_inscription_player(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(inscription_player_url(mock_inscription_player))
      end
    end

    describe "with invalid params" do
      it "updates the requested inscription_player" do
        InscriptionPlayer.should_receive(:find).with("37").and_return(mock_inscription_player)
        mock_inscription_player.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :inscription_player => {:these => 'params'}
      end

      it "assigns the inscription_player as @inscription_player" do
        InscriptionPlayer.stub!(:find).and_return(mock_inscription_player(:update_attributes => false))
        put :update, :id => "1"
        assigns[:inscription_player].should equal(mock_inscription_player)
      end

      it "re-renders the 'edit' template" do
        InscriptionPlayer.stub!(:find).and_return(mock_inscription_player(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested inscription_player" do
      InscriptionPlayer.should_receive(:find).with("37").and_return(mock_inscription_player)
      mock_inscription_player.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the inscription_players list" do
      InscriptionPlayer.stub!(:find).and_return(mock_inscription_player(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(inscription_players_url)
    end
  end

end
