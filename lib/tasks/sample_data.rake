namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_entries
    make_votes
  end
end

def make_users
  admin = User.create!(:name => "Example User",
                 :email => "example@railstutorial.org",
                 :password => "foobar",
                 :password_confirmation => "foobar")
  admin.toggle!(:admin)

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_entries
  User.all(:limit => 6).each do |user|
    50.times do
      user.entries.create!(:title => Faker::Lorem.sentence(5),
         :shortcode => Faker::Lorem.sentence(2),
         :longcode => Faker::Lorem.sentence(6),
         :comments => Faker::Lorem.sentence(8))
    end
  end
end

def make_votes
  user = User.first
  the_voted_for = Entry.all[2..6]
  entry = Entry.find(3)
  the_voting = User.all[3..40]

  # first user votes for some entries
  the_voted_for.each { |e| user.vote!(e) }
  # users with ids 4 through 41 vote for the 4th entry 
  the_voting.each { |u| u.vote!(entry) }
end