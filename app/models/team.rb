# you may call this Working Place, Task, Department or Team
#
# Used to classify Schedulings

require 'digest/md5'

class Team < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :organization
  validates_presence_of :organization

  validates_format_of :color, with: /\A#[0-9A-F]{6}\z/

  attr_accessible :name, :shortcut, :color

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
    super.presence || color_from_name
  end

  def color_before_type_cast
    color
  end

  def shortcut
    super.presence || shortcut_from_name
  end

  # display unsaved default value in form
  def shortcut_before_type_cast
    shortcut
  end

  def shortcut_from_name
    name.split.map(&:first).join
  end

  def color_from_name
    '#' + Digest::MD5.hexdigest(name || Time.now.to_s).first(6).upcase
  end
end
