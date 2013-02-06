Given /^a default overnight shift for #{capture_model} exists$/ do |model_name|
  plan_template = model!(model_name)
  qualification_brennstabpolierer = create(:qualification, name: "Brennstabpolierer",
                                                       organization: plan_template.organization)
  qualification_brennstabexperte  = create(:qualification, name: "Brennstabexperte",
                                                       organization: plan_template.organization)

  create(:team, name: "Brennstabkessel", organization: plan_template.organization)
  team_druckwasserreaktor = create(:team, name: "Druckwasserreaktor",
                                               organization: plan_template.organization)

  demands_attributes = [
    { quantity: 2, qualification_id: qualification_brennstabpolierer.id },
    { quantity: 3 }
  ]

  create(:shift, start_hour: 22, start_minute: 15, end_hour: 6, end_minute: 45, day: 1,
    plan_template: plan_template,
    team: team_druckwasserreaktor,
    demands_attributes: demands_attributes
  )
end

