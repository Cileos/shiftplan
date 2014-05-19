# One ore more established entries, one provoker, causing the Conflict
class Conflict < Struct.new(:provoker, :established)
  include Draper::Decoratable

  def show_details!
    @show_details = true
  end

  def show_details?
    @show_details
  end
end
