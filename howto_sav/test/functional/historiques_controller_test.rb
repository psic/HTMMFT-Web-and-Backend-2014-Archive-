require 'test_helper'

class HistoriquesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:historiques)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create historique" do
    assert_difference('Historique.count') do
      post :create, :historique => { }
    end

    assert_redirected_to historique_path(assigns(:historique))
  end

  test "should show historique" do
    get :show, :id => historiques(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => historiques(:one).id
    assert_response :success
  end

  test "should update historique" do
    put :update, :id => historiques(:one).id, :historique => { }
    assert_redirected_to historique_path(assigns(:historique))
  end

  test "should destroy historique" do
    assert_difference('Historique.count', -1) do
      delete :destroy, :id => historiques(:one).id
    end

    assert_redirected_to historiques_path
  end
end
