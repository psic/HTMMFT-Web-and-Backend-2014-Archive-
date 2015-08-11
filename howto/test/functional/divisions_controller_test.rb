require 'test_helper'

class DivisionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Divisions.first
    assert_template 'show'
  end
end
