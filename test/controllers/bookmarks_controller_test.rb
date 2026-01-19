require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  test "should get polla" do
    get bookmarks_polla_url
    assert_response :success
  end
end
