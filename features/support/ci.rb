if ENV['CI']
  # show diff additionally to "Tables were not identical"
  module MessageWithTableDump
    def message
      super + "\n" + @table.to_s(color: false)
    end
  end
  Cucumber::Ast::Table::Different.send :include, MessageWithTableDump

  Capybara.default_wait_time = 15
end
