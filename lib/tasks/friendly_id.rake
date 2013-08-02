namespace :friendly_id do
  desc 'Generate friendly ids for records that have none'
  task :generate => :environment do
    # migrations should UPDATE the slug = id so the index is uniq. Here we change the numbers to real human slugs.
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.without_timestamps do
        [Organization, Account].each do |model|
          STDERR.puts "reslugging #{model}"
          model.where("slug ~ '\d*'").each do |record|
            STDERR.puts "  #{record.id} #{record.name.inspect}"
            record.slug = nil
            record.save!
          end
        end
      end
    end
  end
end
