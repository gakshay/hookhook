require 'test_helper'

class EligibilitiesControllerTest < ActionController::TestCase
  setup do
    @eligibility = eligibilities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:eligibilities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create eligibility" do
    assert_difference('Eligibility.count') do
      post :create, eligibility: { designation: @eligibility.designation, explore: @eligibility.explore, interest: @eligibility.interest, meet: @eligibility.meet, priority: @eligibility.priority }
    end

    assert_redirected_to eligibility_path(assigns(:eligibility))
  end

  test "should show eligibility" do
    get :show, id: @eligibility
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @eligibility
    assert_response :success
  end

  test "should update eligibility" do
    patch :update, id: @eligibility, eligibility: { designation: @eligibility.designation, explore: @eligibility.explore, interest: @eligibility.interest, meet: @eligibility.meet, priority: @eligibility.priority }
    assert_redirected_to eligibility_path(assigns(:eligibility))
  end

  test "should destroy eligibility" do
    assert_difference('Eligibility.count', -1) do
      delete :destroy, id: @eligibility
    end

    assert_redirected_to eligibilities_path
  end
end
