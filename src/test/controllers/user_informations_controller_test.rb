require "test_helper"

class UserInformationsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @user = users(:one) 
    sign_in @user 
  end

  test "should get new" do
    get new_user_information_url
    assert_response :success
  end

  test "should create user_information" do
    assert_difference('UserInformation.count') do
      post user_information_url, params: { user_information: { user_id: @user.id, first_name: "John", last_name: "Doe", address: "123 Main St", birthdate: "2023-10-12", sex: "Male", phone_number: "07777777777" } }
    end

    assert_equal 'Details saved!', flash[:success]
  end

  test "should handle unsuccessful creation" do
    assert_no_difference('UserInformation.count') do
      post user_information_url, params: { user_information: { first_name: "" } }
    end

    assert_template 'new'
    assert_equal 'Something went wrong', flash[:error]
  end

  test "should destroy user_information" do
    user_information = user_informations(:one) # Assuming you have fixture data for user_informations
    delete user_information_url(user_information)
    assert_equal 'Account information has been successfully deleted.', flash[:notice]
  end

  test "should handle non-existent user_information" do
    delete user_information_url(999) # Assuming 999 is not a valid user_information id
    assert_equal 'User does not have associated account information.', flash[:alert]
  end

end

