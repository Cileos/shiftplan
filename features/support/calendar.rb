module CalendarHelpers
  class Calendar < TableHelpers::Table
    def selector
      world.selector_for('the calendar')
    end

    def employees_with_batches
      rows.map do |tr|
        [
          cleanup_whitespace(tr.first('th:first .employee > .name').try(:text)),
          cleanup_whitespace(tr.first('th:first .wwt_diff .badge').try(:text) || '')
        ]
      end
    end

    def teams_with_batches
      rows.map do |tr|
        [
          cleanup_whitespace(tr.first('th:first .team_name').try(:text)),
          cleanup_whitespace(tr.first('th:first .wwt_diff .badge').try(:text) || '')
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

  end
end
