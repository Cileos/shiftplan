# TODO: do we still need this?
Given /^the following workplaces:$/ do |workplaces|
  workplaces.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(attributes['account'])

    attributes['qualifications'] = attributes['qualifications'].split(',').map do |qualification|
      Qualification.find_by_name(qualification.strip)
    end if attributes.has_key?('qualifications')

    if attributes.has_key?('requirements')
      requirements = attributes.delete('requirements').split(',')

      attributes['qualification_ids'] = requirements.map do |requirement|
        Qualification.find_by_name(requirement.match(/^\d+x (.+)$/)[1].strip).id
      end

      attributes['workplace_requirements'] = requirements.map do |requirement|
        quantity, qualification = requirement.match(/^(\d+)x (.+)$/)[1..-1]
        WorkplaceRequirement.new(
          :qualification => Qualification.find_by_name(qualification.strip),
          :quantity => quantity.to_i
        )
      end
    end

    Workplace.create!(attributes)
  end
end

# TODO: somehow merge this with the above to DRY it up
Given /^the following workplaces for "([^\"]*)":$/ do |account, workplaces|
  workplaces.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(account)

    attributes['qualifications'] = attributes['qualifications'].split(',').map do |qualification|
      Qualification.find_by_name(qualification.strip)
    end if attributes.has_key?('qualifications')

    if attributes.has_key?('requirements')
      requirements = attributes.delete('requirements').split(',')

      # FIXME: this could be an indication that we don't need to separate workplace qualifications and workplace requirements?
      attributes['qualification_ids'] = requirements.map do |requirement|
        Qualification.find_by_name(requirement.match(/^\d+x (.+)$/)[1].strip).id
      end

      attributes['workplace_requirements'] = requirements.map do |requirement|
        quantity, qualification = requirement.match(/^(\d+)x (.+)$/)[1..-1]
        WorkplaceRequirement.new(
          :qualification_id => Qualification.find_by_name(qualification.strip).id,
          :quantity => quantity.to_i
        )
      end
    end

    Workplace.create!(attributes)
  end
end

Then /^I should see a workplace named "([^\"]*)" listed in the sidebar$/ do |name|
  lambda { locate_workplace(name) }.should_not raise_error(Steam::ElementNotFound)
end
