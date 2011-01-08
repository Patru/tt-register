require 'test_helper'

class QuarksControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:quarks)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_quark
    assert_difference('Quark.count') do
      post :create, :quark => { }
    end

    assert_redirected_to quark_path(assigns(:quark))
  end

  def test_should_show_quark
    get :show, :id => quarks(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => quarks(:one).id
    assert_response :success
  end

  def test_should_update_quark
    put :update, :id => quarks(:one).id, :quark => { }
    assert_redirected_to quark_path(assigns(:quark))
  end

  def test_should_destroy_quark
    assert_difference('Quark.count', -1) do
      delete :destroy, :id => quarks(:one).id
    end

    assert_redirected_to quarks_path
  end
end
