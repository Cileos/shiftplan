# you may call this Working Place, Task, Department or Team
#
# Used to classify Schedulings

require 'digest/md5'

class Team < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :organization
  validates_presence_of :organization

  attr_accessible :name, :shortcut

  # Remove outer and double inner spaces
  def name=(new_name)
    if new_name
      super new_name.strip.gsub(/\s{2,}/, '')
    else
      super
    end
  end

  def to_quickie
    %Q~#{name} [#{shortcut}]~
  end

  def color
    '#' + Digest::MD5.hexdigest(name).first(6)
  end

  def shortcut
    super || shortcut_from_name
  end

  # display unsaved default value in form
  def shortcut_before_type_cast
    shortcut
  end

  def shortcut_from_name
    name.split.map(&:first).join
  end
end
