require 'test_helper'

class ClassementsControllerTest < ActionController::TestCase
  def test_show
    get :show, :id => Classement.first
    assert_template 'show'
  end
end
