# you may call this Working Place, Task, Department or Team
#
# Used to classify Schedulings
class Team < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :organization
  validates_presence_of :organization

  # Remove outer and double inner spaces
  def name=(new_name)
    if new_name
      super new_name.strip.gsub(/\s{2,}/, '')
    else
      super
    end
  end

  def to_quickie
    name
  end
end
