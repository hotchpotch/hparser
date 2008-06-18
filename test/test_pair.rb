require 'test_helper'
require 'hparser/parser'
require 'hparser/block/quote'
require 'hparser/block/pre'
require 'hparser/block/super_pre'
class QuoteTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline

  def setup
    @parser = HParser::Parser.new [SuperPre,Pre,Quote,P]
  end

  def parse str
    @parser.parse str
  end

  def assert_pair(from,to,klass)
    assert_equal [P.new([Text.new("#{from}aaa#{to}")])], parse("#{from}aaa#{to}")
    assert_equal [klass.new([Text.new("aaa")])], parse("#{from}\naaa\n#{to}")
    assert_equal [klass.new([Text.new("aaa")])], parse("#{from}\r\naaa\r\n#{to}")
    assert_equal [klass.new([Text.new("aaa")])], parse("#{from}\raaa\r#{to}")
    assert_equal [klass.new([Text.new("aaa\n\nbbb")])],parse(<<-"END")
#{from}
aaa

bbb
#{to}
    END

  end

  def test_quote
    assert_pair ">>","<<",Quote
  end

  def test_pre
    assert_pair ">|","|<",Pre
  end
end
