require 'test_helper'

class AdminsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:admins)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_admin
    assert_difference('Admin.count') do
      create_admin_user
    end

    assert_not_nil(assigns(:admins))
    assert_redirected_to root_path
    assert !ActionMailer::Base.deliveries.empty?
    email = ActionMailer::Base.deliveries.last
    assert_equal [TEST_EMAIL], email.to
    assert_match(/http:\/\/test.host\/admins\/login\/blabla/, email.encoded)
  end

  def test_should_show_admin
    admin = create_and_login_dummy_admin
    get :show, :id => admin.id
    assert_response :success
  end

  def test_should_get_edit
    admin = create_and_login_dummy_admin
    get :edit, :id => admin.id
    assert_response :success
  end

  def test_should_update_admin
    admin=create_and_login_dummy_admin
    put :update, :id => admin.id, :admin => {name: "Test2", password: "blank" }
    assert_redirected_to admin_path(assigns(:admin))
  end

  def test_cannot_destroy_without_login
    admin = create_admin_user
    delete :destroy, :id => admin.id
    assert_redirected_to root_path
  end

  def test_should_destroy_admin
    admin=create_and_login_dummy_admin
    assert_difference('Admin.count', -1) do
      delete :destroy, :id => admin.id
    end

    assert_redirected_to admins_path
  end
end
