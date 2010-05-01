Given /^the following accounts:$/ do |accounts|
  accounts.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['users'] = attributes['users'].split(',').map do |email|
      User.find_by_email(email.strip)
    end
    attributes['subdomain'] = "account-#{Time.current.to_i}"
    Account.create!(attributes)
  end
end

