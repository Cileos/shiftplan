class Requirement < ActiveRecord::Base
  belongs_to :shift
  belongs_to :qualification
  has_one :assignment

  def fulfilled?
    !!assignment
  end
end
