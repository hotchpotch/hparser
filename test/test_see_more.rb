require 'test_helper'
require 'hparser/parser'
require 'hparser/block/see_more'
class SeeMoreTest < Test::Unit::TestCase
  include HParser::Block

  def setup
    @parser = HParser::Parser.new [SeeMore]
  end

  def parse str
    @parser.parse str
  end

  def test_new
    more = SeeMore.new(false)
    all = SeeMore.new(true)
    assert_equal false,more.is_super
    assert_equal true,all.is_super
    assert_not_equal more,all
  end

  def test_parse
    assert_equal [SeeMore.new(false)], parse("====")
    assert_equal [SeeMore.new(true)], parse("=====")
    assert_not_equal [SeeMore.new(false)], parse("====a")
  end
end
