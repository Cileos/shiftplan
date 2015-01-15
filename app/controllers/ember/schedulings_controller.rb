module Ember
  class SchedulingsController < BaseController
    respond_to :json
    def end_of_association_chain
      # TODO filter/paginate
      current_user.schedulings
    end
  end
end
