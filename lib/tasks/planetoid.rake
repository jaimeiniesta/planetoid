namespace :planetoid do
  namespace :fetch do
    desc "Fetch all feeds"
    task :all => :environment do |t|
      puts "Fetching all feeds, please wait..."
      Feed.fetch_all!
      puts "Done!"
    end
  end
end