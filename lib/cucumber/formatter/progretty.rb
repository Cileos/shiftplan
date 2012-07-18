require 'fileutils'
require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'gherkin/formatter/escaping'
module Cucumber
  module Formatter
    # the formatter being a bastard of the original pretty and the progress formatter
    #
    # This formatter prints just progress chars on success, but gives more
    # details on test failure, esp. the table diff
    class Progretty
      include Console
      include Io
      include Gherkin::Formatter::Escaping
      attr_reader :step_mother
      def initialize(step_mother, path_or_io, options)
        @step_mother, @io, @options = step_mother, ensure_io(path_or_io, "progretty"), options
        @exceptions = []
        @prefixes = options[:prefixes] || {}
        @indent = 2
        @delayed_messages = []
      end

      def exception_raised?
        !@exceptions.empty?
      end

      def exception_raised!(exception)
        @exceptions << exception
      end

      def reset_exception_raised!
        @exceptions.clear
      end

      def after_features(features)
        @io.puts
        @io.puts
        print_summary(features)
      end

      def __before_feature(feature)
        reset_exception_raised!
      end

      def before_feature_element(*args)
        reset_exception_raised!
      end

      def after_feature_element(*args)
        progress(:failed) if exception_raised?
        reset_exception_raised!
      end

      def before_steps(*args)
        progress(:failed) if exception_raised?
        reset_exception_raised!
      end

      def after_steps(*args)
        reset_exception_raised!
      end

      def after_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line)
        progress(status)
        @status = status
      end

      def before_outline_table(outline_table)
        @outline_table = outline_table
      end

      def after_outline_table(outline_table)
        @outline_table = nil
      end

      def before_multiline_arg(multiline_arg)
        return if @options[:no_multiline] || @hide_this_step
        @table = multiline_arg
      end
      
      def after_multiline_arg(multiline_arg)
        @table = nil
      end

      def before_table_row(table_row)
        return if !@table || @hide_this_step || !exception_raised?
        @col_index = 0
        if @table.cells_rows.index(table_row) == 0 # first row
          @io.puts
        end
        @io.print '  |'.indent(@indent-2)
      end

      def after_table_row(table_row)
        return if !@table || @hide_this_step || !exception_raised?
        print_table_row_messages
        @io.puts
        if table_row.exception && !@exceptions.include?(table_row.exception)
          print_exception(table_row.exception, table_row.status, @indent)
        end
      end

      def after_table_cell(cell)
        return if !@table || !exception_raised?
        @col_index += 1
      end


      # TODO @table vs @outline_table
      def table_cell_value(value, status)
        return if !@table || @hide_this_step || !exception_raised?
        status ||= @status || :passed
        width = @table.col_width(@col_index)
        cell_text = escape_cell(value.to_s || '')
        padded = cell_text + (' ' * (width - cell_text.unpack('U*').length))
        prefix = cell_prefix(status)
        @io.print(' ' + format_string("#{prefix}#{padded}", status) + ::Cucumber::Term::ANSIColor.reset(" |"))
        @io.flush
      end

      # TODO @hide_this_step
      def exception(exception, status)
        return if @hide_this_step
        print_exception(exception, status, @indent)
        @io.flush
      end

      def before_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line)
        @hide_this_step = false
        if exception
          if @exceptions.include?(exception)
            @hide_this_step = true
            return
          end
          exception_raised!(exception)
        end
        @status = status
      end

      private

      def print_summary(features)
        print_steps(:pending)
        print_steps(:failed)
        print_stats(features, @options)
        print_snippets(@options)
        print_passing_wip(@options)
      end

      CHARS = {
        :passed    => '.',
        :failed    => 'F',
        :undefined => 'U',
        :pending   => 'P',
        :skipped   => '-'
      }

      def progress(status)
        char = CHARS[status]
        @io.print(format_string(char, status))
        @io.flush
      end

      def cell_prefix(status)
        @prefixes[status]
      end

    end
  end
end



module OldCucumber
  module Formatter
    # The formatter used for <tt>--format progress</tt>
    class Progress

      def table_cell_value(value, status)
        return unless @outline_table
        status ||= @status
        progress(status) unless table_header_cell?(status)
      end

      def table_header_cell?(status)
        status == :skipped_param
      end
    end
  end
end


module OldCucumber
  module Formatter
    class Pretty
      include FileUtils
    end
  end
end
