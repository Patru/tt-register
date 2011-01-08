require 'spec_helper'

describe TournamentDaysController do

  def mock_tournament_day(stubs={})
    @mock_tournament_day ||= mock_model(TournamentDay, stubs)
  end

  describe "GET index" do
    it "assigns all tournament_days as @tournament_days" do
      TournamentDay.stub!(:find).with(:all).and_return([mock_tournament_day])
      get :index
      assigns[:tournament_days].should == [mock_tournament_day]
    end
  end

  describe "GET show" do
    it "assigns the requested tournament_day as @tournament_day" do
      TournamentDay.stub!(:find).with("37").and_return(mock_tournament_day)
      get :show, :id => "37"
      assigns[:tournament_day].should equal(mock_tournament_day)
    end
  end

  describe "GET new" do
    it "assigns a new tournament_day as @tournament_day" do
      TournamentDay.stub!(:new).and_return(mock_tournament_day)
      get :new
      assigns[:tournament_day].should equal(mock_tournament_day)
    end
  end

  describe "GET edit" do
    it "assigns the requested tournament_day as @tournament_day" do
      TournamentDay.stub!(:find).with("37").and_return(mock_tournament_day)
      get :edit, :id => "37"
      assigns[:tournament_day].should equal(mock_tournament_day)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created tournament_day as @tournament_day" do
        TournamentDay.stub!(:new).with({'these' => 'params'}).and_return(mock_tournament_day(:save => true))
        post :create, :tournament_day => {:these => 'params'}
        assigns[:tournament_day].should equal(mock_tournament_day)
      end

      it "redirects to the created tournament_day" do
        TournamentDay.stub!(:new).and_return(mock_tournament_day(:save => true))
        post :create, :tournament_day => {}
        response.should redirect_to(tournament_day_url(mock_tournament_day))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved tournament_day as @tournament_day" do
        TournamentDay.stub!(:new).with({'these' => 'params'}).and_return(mock_tournament_day(:save => false))
        post :create, :tournament_day => {:these => 'params'}
        assigns[:tournament_day].should equal(mock_tournament_day)
      end

      it "re-renders the 'new' template" do
        TournamentDay.stub!(:new).and_return(mock_tournament_day(:save => false))
        post :create, :tournament_day => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested tournament_day" do
        TournamentDay.should_receive(:find).with("37").and_return(mock_tournament_day)
        mock_tournament_day.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tournament_day => {:these => 'params'}
      end

      it "assigns the requested tournament_day as @tournament_day" do
        TournamentDay.stub!(:find).and_return(mock_tournament_day(:update_attributes => true))
        put :update, :id => "1"
        assigns[:tournament_day].should equal(mock_tournament_day)
      end

      it "redirects to the tournament_day" do
        TournamentDay.stub!(:find).and_return(mock_tournament_day(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(tournament_day_url(mock_tournament_day))
      end
    end

    describe "with invalid params" do
      it "updates the requested tournament_day" do
        TournamentDay.should_receive(:find).with("37").and_return(mock_tournament_day)
        mock_tournament_day.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :tournament_day => {:these => 'params'}
      end

      it "assigns the tournament_day as @tournament_day" do
        TournamentDay.stub!(:find).and_return(mock_tournament_day(:update_attributes => false))
        put :update, :id => "1"
        assigns[:tournament_day].should equal(mock_tournament_day)
      end

      it "re-renders the 'edit' template" do
        TournamentDay.stub!(:find).and_return(mock_tournament_day(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested tournament_day" do
      TournamentDay.should_receive(:find).with("37").and_return(mock_tournament_day)
      mock_tournament_day.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the tournament_days list" do
      TournamentDay.stub!(:find).and_return(mock_tournament_day(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(tournament_days_url)
    end
  end

end
