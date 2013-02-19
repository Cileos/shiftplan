Given /^a default overnight shift for #{capture_model} exists$/ do |model_name|
  plan_template = model!(model_name)
  qualification_brennstabpolierer = create(:qualification, name: "Brennstabpolierer",
    account: plan_template.organization.account)
  qualification_brennstabexperte  = create(:qualification, name: "Brennstabexperte",
    account: plan_template.organization.account)

  create(:team, name: "Brennstabkessel", organization: plan_template.organization)
  team_druckwasserreaktor = create(:team, name: "Druckwasserreaktor",
    organization: plan_template.organization)

  demands_attributes = [
    { quantity: 2, qualification_id: qualification_brennstabpolierer.id },
    { quantity: 3 }
  ]

  create(:shift, start_hour: 22, end_hour: 6, day: 1,
    plan_template: plan_template,
    team: team_druckwasserreaktor,
    demands_attributes: demands_attributes
  )
end

