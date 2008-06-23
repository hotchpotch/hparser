require 'test_helper'
require 'hparser/parser'
require 'pathname'

class IntegrationTest < Test::Unit::TestCase
  def setup
    @parser = HParser::Parser.new
  end

  def parse str
    @parser.parse str
  end

  def test_parse_ok
    Pathname.glob(Pathname.new(__FILE__).parent.to_s + '/integration_texts/*.ok.hatena').each do |file|
      assert parse(file.read), file.to_s
    end
  end
end

