module CalendarHelpers
  SelectorsForTextExtraction = ['.day_name', '.employee_name', '.work_time', '.team_name',
    'a.button.active', 'li.dropdown a.button', '.demand', '.qualification_name']

  class Calendar < Struct.new(:world)
    def element
      world.find( world.selector_for('the calendar') )
    end

    def columns
      element.all('thead tr th')
    end

    def rows
      element.all('tbody th')
    end


    def clear_cache!
      @columns = nil
      @rows = nil
    end

    def cache!
      # TODO extract
      @columns = columns.map {|c| extract_text_from_cell c }
      @rows = rows.map {|c| extract_text_from_cell c }
    end

    # 0-based index of column headed by given label
    def column_index_for(column_label)
      if cached = lookup_index(@columns, column_label)
        return cached
      end
      labels = []
      columns.each_with_index do |cell, index|
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
      if cached = lookup_index(@rows, row_label)
        return cached
      end
      labels = []
      rows.each_with_index do |cell, index|
        seen = extract_text_from_cell cell
        if seen == row_label
          return index
        else
          labels << seen
        end
      end
      raise %Q~could not find row #{row_label.inspect} in #{labels.inspect}~
    end

    def lookup_index(store,label)
      if store.present? # we have a cached value
        store.index(label)
      end
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
