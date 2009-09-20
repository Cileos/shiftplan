class Requirement < ActiveRecord::Base
  belongs_to :shift
  belongs_to :qualification, :class_name => 'Tag'
  has_one :assignment

  def fulfilled?
    !!assignment
  end
end
