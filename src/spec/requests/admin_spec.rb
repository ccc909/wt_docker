require 'rails_helper'

RSpec.describe "Admin", type: :request do
  
  before(:each) do
    @admin = FactoryBot.create(:admin)
    @admin.confirm

    @user = FactoryBot.create(:user)
    @user.confirm

    @company = FactoryBot.create(:company)
    @company.confirm

    @user_information = UserInformation.create(
    first_name: "John",
    last_name: "Doe",
    country: "1",
    county: "2",
    city: "1213",
    address: "oifdjsf",
    birthdate: "2020-07-06",
    sex: "Male",
    phone_number: "0123456789",
    user_id: @user.id
    )

    @company_information = CompanyInformation.create(
    name: "TestingCompany",
    country: "Romania",
    address: "Bruh",
    phone_number: "0123456789",
    user_id: @company.id
    )

  end

  #check block against non-admins
  it "blocks access of non-admin users" do
    sign_in @user

    get admin_index_path    
    expect(response).to have_http_status(302)
  end

  it "blocks not logged-in users" do
    get admin_index_path
    expect(response).to have_http_status(302)
  end

  #check if admin status can be toggled on and off
  it "updates admin status of another user" do
    sign_in @admin
    before = @user.admin

    patch update_admin_path(@user.id), as: :json

    @user.reload
    expect(@user.admin).to eq(!before)
  end

  #check if admin can toggle blocked status of users
  it "blocks users as admin" do
    sign_in @admin
    before = @user.blocked

    patch block_user_path(@user.id), as: :json

    @user.reload
    expect(@user.blocked).to eq(!before)
  end

  it "user information is created" do
    expect(@user.user_information.present?).to eq(true)
  end

  #check if search fills @users with matching users
  it "finds matching user on search" do 
    sign_in @admin

    get search_users_admin_path, params: { search: "j" }, xhr: true

    expect(assigns(:users)).to include(@user)
  end

  #check if search works correctly
  it "does not find not matching user on search" do 
    sign_in @admin

    get search_users_admin_path, params: { search: "not existing name" }, xhr: true

    expect(assigns(:users)).not_to include(@user)
  end

  #correctly enables/disables a company
  it "enables/disables company" do
    sign_in @admin
    before = @company.enabled

    patch enable_company_path(@company_information.id)

    @company.reload
    expect(@company.enabled).to eq(!before)

    patch enable_company_path(@company_information.id)
    @company.reload

    expect(@company.enabled).to eq(before)
  end

  #admin correctly adds verification status
  it "adds verification status + disables user" do
    sign_in @admin
    before = "Pending verification"

    expect(@company_information.status).to eq(before)
    @company.update(enabled: true) #enable to check if message disables it

    patch add_verification_status_path(@company_information.id), params: { company_information: {status: "Disabled for a reason"} }, as: :js
    @company.reload
    @company_information.reload

    expect(@company_information.status).to eq("Disabled for a reason")
    expect(@company.enabled).to eq(false)
  end

  #check status change on company information update
  it "adds resets verification status on company information update" do
    sign_in @company

    before = "Disabled"
    @company_information.update(status: before)

    patch company_information_path(@company_information.id), params: { company_information: { name: "Another Name" } }, as: :json
    @company_information.reload

    expect(@company_information.name).to eq("Another Name")
    expect(@company_information.status).to eq("Pending verification")
  end

end
