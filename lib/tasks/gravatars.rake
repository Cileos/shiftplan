namespace :gravatars do
  desc "Download gravatars of users and save them as their avatar if none present"
  task :update => :environment do
    GravatarUpdater.new.run
  end
end
