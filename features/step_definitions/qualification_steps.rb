Given /^the following qualifications:$/ do |qualifications|
  qualifications.hashes.each do |qualification_attributes|
    Qualification.create!(qualification_attributes)
  end
end