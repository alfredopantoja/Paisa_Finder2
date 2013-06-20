namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")
		admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
		32.times do
			name = Faker::Name.name
			State.create!(name: name)
		end	
		states = State.all(limit: 6)
		50.times do
			name = Faker::Name.name				
			states.each { |state| state.municipalities.create!(name: name) }
		end	
    municipalities = Municipality.all(limit: 6)
    50.times do
      name = Faker::Name.name
      municipalities.each { |muni| muni.towns.create!(name: name) }
    end  
    towns = Town.all(limit: 6)
    50.times do
      title = Faker::Lorem.sentence
      body = Faker::Lorem.paragraphs
      towns.each { |town| town.posts.create!(title: title, body: body) }
    end  
  end
end
