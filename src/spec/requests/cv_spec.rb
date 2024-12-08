require 'rails_helper'

RSpec.describe "Cv", type: :request do
  
  before(:each) do
    @user = FactoryBot.create(:user)
    @user.confirm

    

    @user2 = FactoryBot.create(:user2)
    @user2.confirm

    @skills = FactoryBot.create_list(:skill, 5)

    @cv = Cv.create(title: "Example CV", user_id: @user.id)

    @experience = Experience.create(title: "Test", 
                                    employer: "Company", 
                                    description: "Worker",
                                    started_at: Date.new(2002, 3, 3),
                                    finished_at: nil,
                                    ongoing: true,
                                    cv_id: @cv.id 
                                  )

    @education = Education.create(  institution: "Testing", 
                                    specialization: "IT", 
                                    degree: "Bachelor",
                                    started_at: Date.new(2002, 3, 3),
                                    finished_at: nil,
                                    ongoing: true,
                                    cv_id: @cv.id
                                  )

  end

  #check access if not logged in
  it "redirects if not signed in on profile access" do
    get profile_index_path 
    expect(response).to have_http_status(302)
  end

  #check success on profile view
  it "returns success response on user profile" do
    sign_in @user
    get profile_index_path 
    expect(response).to have_http_status(200)
  end

  #check success cv creation
  it "successfully creates a cv" do
    sign_in @user 
    post cv_index_path, params: { cv: { title: 'Sample CV' } }
    
    expect(Cv.last.title).to eq('Sample CV')
  end

  #education creation for cv
  it "successfully adds education to cv" do
    sign_in @user

    education_params = { education: { 
                                    institution: "Example", 
                                    specialization: "IT", 
                                    degree: "Bachelor",
                                    started_at: Date.new(2002, 7, 9),
                                    finished_at: nil,
                                    ongoing: true,
                                    
                                  }, 
                        cv_id: @cv.id
                      }

    post create_education_cv_path(@cv.id), params: education_params, as: :json

    expect(Education.last.institution).to eq("Example")
    expect(Education.last.cv_id).to eq(@cv.id)
  end

  #experience creation for cv
  it "successfully adds experience to cv" do
    sign_in @user

    experience_params = { experience: { 
                                    title: "Example", 
                                    employer: "Company", 
                                    description: "Worker",
                                    started_at: Date.new(2002, 7, 9),
                                    finished_at: nil,
                                    ongoing: true,
                                  }, 
                        cv_id: @cv.id
                      }

    post create_experience_cv_path(@cv.id), params: experience_params, as: :json

    expect(Experience.last.title).to eq("Example")
    expect(Experience.last.cv_id).to eq(@cv.id)
  end

  #check success add skills to cv
  it "succesfully updates skills to cv" do
    sign_in @user

    skill_ids = { cv: {skill_ids: [@skills[1].id, @skills[2].id, @skills[3].id] },
                  cv_id: @cv.id 
                } 

    patch add_skills_cv_path(@cv.id), params: skill_ids, as: :json
    
    expect(@cv.skills.pluck(:id)).to match_array(skill_ids[:cv][:skill_ids])
  end

  #check cv deletion
  it "succesfully deletes cv" do 
    sign_in @user

    delete cv_path(@cv.id)

    expect(Cv.exists?(@cv.id)).to eq(false)
  end

  #check experience of cv deletion
  it "successfully deletes experience" do
    sign_in @user

    delete delete_experience_cv_path(@experience.id), params: {cv_id: @cv.id}

    expect(Experience.exists?(@experience.id)).to eq(false)
  end

  #check education of cv deletion
  it "successfully deletes education" do
    sign_in @user

    delete delete_education_cv_path(@education.id), params: {cv_id: @cv.id}

    expect(Education.exists?(@education.id)).to eq(false)
  end

  it "doesn't allow other users to edit education/experience" do
    sign_in @user2

    delete delete_education_cv_path(@education.id), params: {cv_id: @cv.id}

    expect(response).to have_http_status(302)
    expect(Education.exists?(@education.id)).to eq(true)
  end

  it "doesn't allow other users to edit skills" do
    sign_in @user2

    prev_skills = @cv.skills

    skill_ids = { cv: {skill_ids: [@skills[1].id, @skills[4].id, @skills[3].id] },
                  cv_id: @cv.id 
                } 

    patch add_skills_cv_path(@cv.id), params: skill_ids, as: :json

    expect(response).to have_http_status(302)
    expect(@cv.skills).to eq(prev_skills)
  end

  it "doesn't allow other users to delete cv" do
    sign_in @user2

    delete cv_path(@cv.id)

    expect(response).to have_http_status(302)
    expect(Cv.exists?(@cv.id)).to eq(true)
  end

end
