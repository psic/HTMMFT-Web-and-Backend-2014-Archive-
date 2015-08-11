require 'test_helper'

class SaisonsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:saisons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create saison" do
    assert_difference('Saison.count') do
      post :create, :saison => { }
    end

    assert_redirected_to saison_path(assigns(:saison))
  end

  test "should show saison" do
    get :show, :id => saisons(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => saisons(:one).id
    assert_response :success
  end

  test "should update saison" do
    put :update, :id => saisons(:one).id, :saison => { }
    assert_redirected_to saison_path(assigns(:saison))
  end

  test "should destroy saison" do
    assert_difference('Saison.count', -1) do
      delete :destroy, :id => saisons(:one).id
    end

    assert_redirected_to saisons_path
  end
end
