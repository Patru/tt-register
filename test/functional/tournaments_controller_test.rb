require 'test_helper'

class TournamentsControllerTest < ActionController::TestCase
  TOURNAMENT_MIN_PARAMS = {tour_id: "Testeo", sender_email: "testeo@nowhere.net", name: "Testeo Turnier"}
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tournaments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tournament" do
    assert_difference('Tournament.count') do
      post :create, :tournament => TOURNAMENT_MIN_PARAMS
    end

    assert_redirected_to tournament_path(assigns(:tournament))
  end

  test "should show tournament" do
    get :show, :id => tournaments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tournaments(:one).to_param
    assert_response :success
  end

  test "should update tournament" do
    put :update, :id => tournaments(:one).to_param, :tournament => TOURNAMENT_MIN_PARAMS
    assert_redirected_to tournament_path(assigns(:tournament))
  end

  test "should destroy tournament" do
    assert_difference('Tournament.count', -1) do
      delete :destroy, :id => tournaments(:one).to_param
    end

    assert_redirected_to tournaments_path
  end
end
