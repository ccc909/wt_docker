# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create users
# db/seeds.rb

# Create 50 users with associated UserInformation records
# db/seeds.rb

# First code block: Creating users, their information, skills, CVs, education, and experience

20.times do |n|
  @user = User.create(email: "user#{n + 1}@example.com", password: "password#{n + 1}")
  UserInformation.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    country: Faker::Address.country,
    county: Faker::Address.state,
    city: Faker::Address.city,
    address: Faker::Address.street_address,
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    sex: Faker::Gender.binary_type,
    phone_number: Faker::PhoneNumber.phone_number,
    user_id: @user.id
  )
  skill = Skill.create(title: "Skill #{n + 1}")
  @cv = Cv.create(title: Faker::Lorem.words(number: 3).join(' '), user_id: @user.id)

  Education.create(
    institution: Faker::University.name,
    specialization: Faker::Educator.subject,
    degree: Faker::Educator.degree,
    started_at: Faker::Date.between(from: 10.years.ago, to: Date.today),
    finished_at: Faker::Date.between(from: 5.years.ago, to: Date.today),
    ongoing: false,
    cv_id: @cv.id
  )
  Experience.create(
    title: Faker::Job.title,
    employer: Faker::Company.name,
    description: Faker::Lorem.paragraph,
    started_at: Faker::Date.between(from: 10.years.ago, to: Date.today),
    finished_at: Faker::Date.between(from: 5.years.ago, to: Date.today),
    ongoing: false,
    cv_id: @cv.id
  )
  @cv.skills << skill
end


# add all cities
json_data = File.read(Rails.root.join('db/cities', 'cities.json'))
cities = JSON.parse(json_data)

cities.each do |city_data|
  Location.find_or_create_by(city: city_data['city'])
end

# Second code block: Creating company information, jobs, and job applications
20.times do |n|
  @company_user = User.create(email: "company#{n + 1}@example.com", password: "password#{n + 1}", company: true)
  CompanyInformation.create(
    name: Faker::Company.name,
    country: Faker::Address.country,
    address: Faker::Address.street_address,
    phone_number: Faker::PhoneNumber.phone_number,
    user_id: @company_user.id
  )

  5.times do |m|
    @job = Job.create(
      title: Faker::Job.title,
      description: Faker::Lorem.paragraph,
      user_id: @company_user.id
    )

    @job.locations << Location.order('RANDOM()').limit(2)
    @job.skills << Skill.order('RANDOM()').limit(4)

    Cv.all.sample(4).each do |cv|
      Application.create(cv_id: cv.id, job_id: @job.id)
    end
  end

  User.create(email:"a@a.com", password:"123456", admin: true, confirmed_at: DateTime.now())
  User.create(email:"admin@gmail.com", password:"123456", admin: true, confirmed_at: DateTime.now())
  User.create(email:"user@gmail.com", password:"123456", confirmed_at: DateTime.now())
  User.create(email:"aa@aa.com", password:"123456", company: true, confirmed_at: DateTime.now(), enabled:true)
  User.create(email:"company@gmail.com", password:"123456", company: true, confirmed_at: DateTime.now(), enabled:true)

end
