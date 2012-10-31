# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h( translate_action(page_title) ) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def sidebar(&block)
    content_for :sidebar, &block
  end

  def contextual_help(&block)
    content_for :contextual_help, &block
  end

  def content_class(number_of_columns=nil)
    number_of_columns = columns_count() unless number_of_columns
    case number_of_columns
      when 3 then 'three-columns'
      when 2 then 'two-columns'
      else nil
    end
  end

  def contextual_help_class(number_of_columns=nil)
    number_of_columns = columns_count() unless number_of_columns
    case number_of_columns
      when 3 then 'tertiary'
      when 2 then 'secondary'
      else nil
    end
  end

  def columns_count(minimum=nil)
    sidebar = (content_for? :sidebar) ? 1 : 0
    contextual_help = (content_for? :contextual_help) ? 1 : 0
    col_count = 1 + sidebar + contextual_help
    (minimum && col_count < minimum) ? minimum : col_count
  end
end
