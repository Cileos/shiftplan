class Setup < ActiveRecord::Base
  belongs_to :user

  def execute!
    # TODO create ALL the stuff like Signup does currently
  end

  class << self
    def default_account_name
      "Meine Firma"
    end

    def default_organization_name
      "Meine Organisation"
    end

    def default_plan_name
      "Mein erster Plan"
    end
  end
end
