require 'test_helper'

class MonEquipesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => MonEquipe.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    MonEquipe.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    MonEquipe.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to mon_equipe_url(assigns(:mon_equipe))
  end

  def test_edit
    get :edit, :id => MonEquipe.first
    assert_template 'edit'
  end

  def test_update_invalid
    MonEquipe.any_instance.stubs(:valid?).returns(false)
    put :update, :id => MonEquipe.first
    assert_template 'edit'
  end

  def test_update_valid
    MonEquipe.any_instance.stubs(:valid?).returns(true)
    put :update, :id => MonEquipe.first
    assert_redirected_to mon_equipe_url(assigns(:mon_equipe))
  end

  def test_destroy
    mon_equipe = MonEquipe.first
    delete :destroy, :id => mon_equipe
    assert_redirected_to mon_equipes_url
    assert !MonEquipe.exists?(mon_equipe.id)
  end
end
