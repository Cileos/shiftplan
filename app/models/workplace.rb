class Workplace < ActiveRecord::Base
  has_many :allocations

  validates_presence_of :name

  def color
    @color ||= begin
      color = read_attribute(:color)
      "##{color}" unless color.blank? || color.starts_with?('#')
    end
  end

  def color=(color)
    color = color.to_s if color
    write_attribute(:color, color.starts_with?('#') ? color[1..-1] : color)
  end
end
