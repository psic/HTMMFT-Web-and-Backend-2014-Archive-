require 'test_helper'

class ContratsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contrats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contrat" do
    assert_difference('Contrat.count') do
      post :create, :contrat => { }
    end

    assert_redirected_to contrat_path(assigns(:contrat))
  end

  test "should show contrat" do
    get :show, :id => contrats(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => contrats(:one).id
    assert_response :success
  end

  test "should update contrat" do
    put :update, :id => contrats(:one).id, :contrat => { }
    assert_redirected_to contrat_path(assigns(:contrat))
  end

  test "should destroy contrat" do
    assert_difference('Contrat.count', -1) do
      delete :destroy, :id => contrats(:one).id
    end

    assert_redirected_to contrats_path
  end
end
