require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get bc_auth" do
    get :bc_auth
    assert_response :success
  end

end
