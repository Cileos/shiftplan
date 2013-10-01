# Naive way to record a screencast
#
# you need to install imagemagick for this to work
require 'fileutils'

module Cucumber::Screencast
  def self.included(base)
    base.class_eval do
      attr_reader :current_frame
    end
  end
  def start_screencast!
    @current_frame = 1
    FileUtils.rm_rf current_screencast_path.to_s
    next_screencast_frame('start')
  end

  def finish_screencast!
    next_screencast_frame('finish')
    # TODO create animation
  end

  def next_screencast_frame(*a)
    save_screencast_frame(*a)
    @current_frame +=1
  end

  def current_frame_path(tail='')
    current_screencast_path.join sprintf("frame_%04d%s.png",current_frame,tail)
  end

  def screenshot
    save_screenshot next_screenshot_path
  end

  private
  def next_screenshot_path
    $current_screenshot ||= 0
    $current_screenshot += 1
    screenshots_path.join sprintf("screenshot_%04d.png", $current_screenshot)
  end

  def save_screenshot(path)
    FileUtils.mkdir_p path.dirname
    system 'import', '-window', 'root', path.to_s
    path
  end


  def save_screencast_frame(*a)
    save_screenshot current_frame_path(*a)
  end

  def screencasts_path
    Rails.root.join('log/screencasts')
  end

  def screenshots_path
    Rails.root.join('log/screenshots')
  end

  def feature_screencast_path
    screencasts_path.join(feature.name.split(/\n/).first)
  end

  def current_screencast_path
    feature_screencast_path.join(name.underscore)
  end

end

unless ENV['NO_SCREENCASTS'].present?

  World( Cucumber::Screencast )

  Cucumber::Ast::Scenario.class_eval do
    include Cucumber::Screencast
  end

  Cucumber::Ast::ScenarioOutline.class_eval do
    include Cucumber::Screencast
  end

  Before '@screencast' do |scenario|
    scenario.start_screencast!
  end

  AfterStep '@screencast' do |scenario|
    scenario.next_screencast_frame
  end

  After '@screencast' do |scenario|
    scenario.finish_screencast!
  end

else

  Rails.logger.debug { "will take no screencasts because NO_SCREENCASTS is set"}

end
