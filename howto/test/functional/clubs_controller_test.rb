require 'test_helper'

class ClubsControllerTest < ActionController::TestCase
  def test_show
    get :show, :id => Club.first
    assert_template 'show'
  end

  def test_index
    get :index
    assert_template 'index'
  end
end
