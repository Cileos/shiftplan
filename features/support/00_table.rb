module TableHelpers
  SelectorsForTextExtraction = [
    '.day_name',
    '.employee > .name',
    '.work_time',
    '.team_name',
    'a.button.active',
    'li.dropdown > a[data-toggle=dropdown]',
    'li.dropdown a.button',
    '.demand',
    '.qualification_name',
    '.conflict'
  ]


  class Table < Struct.new(:world)
    def initialize(world, options={})
      super(world)
      @options = options
    end

    def element
      html = world.evaluate_script(%Q~jQuery('#{selector}').html()~)
      Capybara::Node::Simple.new(html)
    rescue Capybara::NotSupportedByDriverError => e
      world.find( selector )
    end

    def row_selector
      @options.fetch(:row_selector) { "thead:first tr, tbody tr" }
    end

    def selector
      @options.fetch(:selector) { 'table' }
    end

    def column_headings
      element.all('thead tr th')
    end

    def row_headings
      element.all('tbody th')
    end

    def rows
      element.all('tbody tr')
    end

    # 0-based index of column headed by given label
    def column_index_for(column_label)
      labels = []
      column_headings.each_with_index do |cell, index|
        seen = extract_text_from_cell cell
        if seen == column_label
          return index
        else
          labels << seen
        end
      end
      raise %Q~could not find column #{column_label} in #{labels.inspect}~
    end

    # 0-based index of row (in tbody) headed by given label
    def row_index_for(row_label)
      labels = []
      row_headings.each_with_index do |cell, index|
        seen = extract_text_from_cell cell
        if seen.include?(row_label)
          return index
        else
          labels << seen
        end
      end
      raise %Q~could not find row #{row_label.inspect} in #{labels.inspect}~
    end

    # THIS is frakking slow, avoid calling it too often when pre-caching is not possible
    def extract_text_from_cell(cell)
      found = SelectorsForTextExtraction.select { |s| cell.all(s).count > 0 }
      cleanup_whitespace(
        if found.present?
          found.map { |f| cell.all(f).map(&:text).map(&:strip) }.flatten.join(' ')
        else
          clean_text_from_cell(cell)
        # remove newlines and other whitespacery
        end
      )
    end

    # Takes the text from the cell and removes text from :ignore elements
    #
    def clean_text_from_cell(cell)
      cell.text.tap do |text|
        if ignored = @options.fetch(:ignore) { nil }
          cell.all(ignored).each do |e|
            text = text.sub!(e.text, '')
          end
        end
      end
    end

    def cleanup_whitespace(text)
      text.strip.gsub(/\s+/, ' ').squeeze(' ')
    end

    def parsed
      element.all(row_selector).map do |tr|
        # Nokogiri does not respect DOM order, so "td,th" <=> "th,td"
        tr.all('> *').map do |cell|
          if cell.tag_name.in?(%w(td th))
            extract_text_from_cell(cell) || ''
          end
        end.compact
      end
    end

  end
end
