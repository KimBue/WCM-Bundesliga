require 'test_helper'

class KarteControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get karte_index_url
    assert_response :success
  end

end
