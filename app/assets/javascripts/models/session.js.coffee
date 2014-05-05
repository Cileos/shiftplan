attr = DS.attr

# basically there is only one session (with id: "current") to handle
# information of the currently signed in user.

Clockwork.Session = DS.Model.extend
  role: attr('string')
  canManageEmployees: attr('boolean')
