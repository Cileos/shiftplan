# encoding: utf-8
#
# you may call this Working Place, Task, Department or Team
#
# Used to classify Schedulings

require 'digest/md5'

class Team < ActiveRecord::Base
  include Draper::Decoratable
  include Volksplaner::ShortcutAttribute

  belongs_to :organization
  has_many :schedulings

  validates :name, :organization, presence: true
  validates_format_of :color, with: /\A#[0-9A-F]{6}\z/
  # must correspond with Quickie#team_name
  validates_format_of :name, with: Volksplaner::NameRegEx
  validates_uniqueness_of :name, scope: :organization_id

  def self.default_sorting
    order(:name)
  end

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

  def color=(new_color)
    if new_color
      super new_color.upcase
    else
      super
    end
  end

  def color_before_type_cast
    color
  end

  def color_from_name
    '#' + Digest::MD5.hexdigest(name || Time.zone.now.to_s).first(6).upcase.tr('DEF', '789')
  end

  def build_team_merge(attrs={})
    TeamMerge.new attrs.merge(:team_id => id)
  end
end

TeamDecorator
