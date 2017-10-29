require 'test_helper'

class LeagueControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get league_index_url
    assert_response :success
  end

  test "should get show" do
    get league_show_url
    assert_response :success
  end

end
