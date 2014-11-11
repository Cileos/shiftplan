Then /^(?:I|they) should not see "([^"]*?)" in the email body$/ do |text|
  current_email.default_part_body.to_s.should_not include(text)
end

And /^the confirmation email was sent for #{capture_model}$/ do |change|
  email_change = model!(change)
  email_change.send_confirmation_mail
end
