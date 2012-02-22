module Quickie
  require_dependency 'quickie/nodes'

  def self.parse(string)
    parser.parse(string)
  end

  # reloads the parser
  def self.reload_parser!
    if defined?(QuickieParser)
      Object.send :remove_const, :QuickieParser
    end
    @parser = nil
    @parser_class = nil
    parser
  end

  private

  def self.parser_class
    @parser_class ||= Treetop::load (Rails.root/'lib'/'quickie.treetop').to_s
  end

  def self.parser
    @parser ||= parser_class.new
  end
end
