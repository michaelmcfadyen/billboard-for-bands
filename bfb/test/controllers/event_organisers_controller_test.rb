require 'test_helper'

class EventOrganisersControllerTest < ActionController::TestCase
  setup do
    @event_organiser = event_organisers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_organisers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_organiser" do
    assert_difference('EventOrganiser.count') do
      post :create, event_organiser: { firstName: @event_organiser.firstName, lastName: @event_organiser.lastName, password: @event_organiser.password, phoneNumber: @event_organiser.phoneNumber }
    end

    assert_redirected_to event_organiser_path(assigns(:event_organiser))
  end

  test "should show event_organiser" do
    get :show, id: @event_organiser
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event_organiser
    assert_response :success
  end

  test "should update event_organiser" do
    patch :update, id: @event_organiser, event_organiser: { firstName: @event_organiser.firstName, lastName: @event_organiser.lastName, password: @event_organiser.password, phoneNumber: @event_organiser.phoneNumber }
    assert_redirected_to event_organiser_path(assigns(:event_organiser))
  end

  test "should destroy event_organiser" do
    assert_difference('EventOrganiser.count', -1) do
      delete :destroy, id: @event_organiser
    end

    assert_redirected_to event_organisers_path
  end
end
