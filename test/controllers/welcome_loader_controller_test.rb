require 'test_helper'

class WelcomeLoaderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get welcome_loader_index_url
    assert_response :success
  end

end
