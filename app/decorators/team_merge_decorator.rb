class TeamMergeDecorator < TabularizedRecordDecorator

  private

    def records
      h.current_organization.teams
    end

    def records_css_class
      'teams'
    end

    def table_partial_name
      'teams/table'
    end
end
