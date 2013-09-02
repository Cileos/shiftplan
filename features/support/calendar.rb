module CalendarHelpers
  SelectorsForTextExtraction = ['.day_name', '.employee_name', '.work_time', '.team_name',
    'a.button.active', 'li.dropdown a.button', '.demand', '.qualification_name']

  class Table < Struct.new(:world)
    def element
      world.find( selector )
    end

    def selector
      'table'
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

    # THIS is frakking slow, avoid calling it too often
    def extract_text_from_cell(cell)
      found = SelectorsForTextExtraction.select { |s| cell.all(s).count > 0 }
      if found.present?
        found.map { |f| cell.all(f).map(&:text).map(&:strip) }.flatten.join(' ')
      else
        cell.text.strip
      end
    end

  end

  class Calendar < Table
    def selector
      world.selector_for('the calendar')
    end

    def employees_with_batches
      rows.map do |tr|
        [
          tr.first('th:first span.employee_name').try(:text),
          tr.first('th:first .wwt_diff .badge').try(:text)
        ]
      end
    end

    def teams_with_batches
      rows.map do |tr|
        [
          tr.first('th:first .team_name').try(:text),
          tr.first('th:first .wwt_diff .badge').try(:text) || ''
        ]
      end
    end

    def clear_cache!
      @column_headings = nil
      @row_headings = nil
    end

    def cache!
      # TODO extract
      @column_headings = column_headings.map {|c| extract_text_from_cell c }
      @row_headings = row_headings.map {|c| extract_text_from_cell c }
    end

    # 0-based index of column headed by given label
    def column_index_for(column_label)
      if cached = lookup_index(@column_headings, column_label)
        return cached
      end
      super
    end

    # 0-based index of row (in tbody) headed by given label
    def row_index_for(row_label)
      if cached = lookup_index(@row_headings, row_label)
        return cached
      end
      super
    end

    def lookup_index(store,label)
      if store.present? # we have a cached value
        store.index(label)
      end
    end

    # TODO fetch once to extract text more quickly
    def parsed
      element.all("thead:first tr, tbody tr").map do |tr|
        tr.all('th, td').map do |cell|
          extract_text_from_cell(cell) || ''
        end
      end
    end

  end
end
