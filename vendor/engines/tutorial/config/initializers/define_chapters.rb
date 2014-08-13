Tutorial.define_chapter 'email' do |user|
  # not signedin
  user.nil? || user.new_record?
end

Tutorial.define_chapter 'account' do |user|
  # owns no accounts
  user.owned_accounts.blank?
end

Tutorial.define_chapter 'organization' do |user|
  # owns no organizations
  user.owned_organizations.blank?
end

Tutorial.define_chapter 'employee' do |user|
  # does not have any employees except himself
  (user.employees_in_owned_accounts - user.employees).blank?
end

Tutorial.define_chapter 'team' do |user|
  # does not own any teams
  user.owned_organizations.preload(:teams).all? do |org|
    org.teams.blank?
  end
end

Tutorial.define_chapter 'plan' do |user|
  # does not own any plans
  user.owned_organizations.preload(:plans).all? do |org|
    org.plans.blank?
  end
end

Tutorial.define_chapter 'scheduling' do |user|
  # has scheduled ANYone
  user.schedulings.blank?
end
