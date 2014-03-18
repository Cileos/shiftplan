module SchedulingsHelper
  def represents_unavailability_options
    scope = 'schedulings.represents_unavailability'
    [ [t('available', scope: scope), false], [t('busy', scope: scope), true] ]
  end
end
