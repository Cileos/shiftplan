module Quickie
  require_dependency 'quickie/nodes'
  Parser = Treetop::load (Rails.root/'lib'/'quickie.treetop').to_s

  def self.parse(string)
    Parser.new.parse(string)
  end
end
