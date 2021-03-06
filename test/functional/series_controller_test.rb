require 'test_helper'

class SeriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:series)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not create incomparable series" do
    assert_no_difference('Series.count') do
      post :create, :series => {"start_time(1i)" => "2012", "start_time(2i)" => "12", "start_time(3i)" => "28",
                                "start_time(4i)" => "12", "start_time(5i)" => "00"}
    end
    assert_template :new
  end

  test "should create comparable series" do
    assert_difference('Series.count') do
      post :create, :series => {"start_time(1i)" => "2012", "start_time(2i)" => "12", "start_time(3i)" => "28",
                                "start_time(4i)" => "12", "start_time(5i)" => "00", "max_ranking" => "20",
                                "min_ranking" => "1", "category" => ""}
    end
    assert_redirected_to series_path(assigns(:series))
  end

  test "should show series" do
    get :show, :id => series(:menD).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => series(:menD).to_param
    assert_response :success
  end

  test "should update series" do
    put :update, :id => series(:menD).to_param, :series => { }
    assert_redirected_to series_path(assigns(:series))
  end

  test "should destroy series" do
    assert_difference('Series.count', -1) do
      delete :destroy, :id => series(:menD).to_param
    end

    puts series_path
    assert_redirected_to "/series"
  end
end
