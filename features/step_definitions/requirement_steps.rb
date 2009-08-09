Given /^the following requirements:$/ do |requirements|
  requirements.hashes.each do |attributes|
    workplace = Workplace.find_or_create_by_name(attributes['workplace'])
    start_time, end_time = attributes['start'], attributes['end']
    quantity = attributes['quantity']

    Requirement.create!(
      :workplace => workplace,
      :start => start_time,
      :end => end_time,
      :quantity => quantity
    )
  end
end