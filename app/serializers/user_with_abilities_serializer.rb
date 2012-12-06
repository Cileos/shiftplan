# With this we transfer abilities to Ember, by putting it into
# Clockwork.session, so you can check for it in a handlebars template as
# follows:
#
#   {{#if Clockwork.session.can_tie_shoes}}
#     <a {{action tieShoes href=true}}>Tie my Shoes</a>
#   {{/if}}
#
class UserWithAbilitiesSerializer < ApplicationSerializer
  attributes :id, :email

  def attributes
    ability = Ability.new(object)
    super.tap do |hash|
      # actually, only the milestone in the current plan :/
      hash['can_manage_milestone'] = ability.can?(:manage, Milestone)
      hash['can_manage_task'] = ability.can?(:manage, Task)
    end
  end
end
