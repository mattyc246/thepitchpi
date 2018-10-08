require 'test_helper'

class LocksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get locks_index_url
    assert_response :success
  end

  test "should get new" do
    get locks_new_url
    assert_response :success
  end

  test "should get create" do
    get locks_create_url
    assert_response :success
  end

  test "should get show" do
    get locks_show_url
    assert_response :success
  end

  test "should get edit" do
    get locks_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get locks_destroy_url
    assert_response :success
  end

end
