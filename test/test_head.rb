require 'test/unit'
require 'hparser/parser'
require 'hparser/block/head'
require 'hparser/inline/text'
class HeadTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline

  def setup
    @parser = HParser::Parser.new [Head]
  end

  def parse str
    @parser.parse str
  end

  def test_head
    assert_equal [head(1,"aaa")],parse("*aaa")
    assert_equal [head(2,"aaa")], parse("**aaa")
    assert_equal [head(3,"aaa")], parse("***aaa")
  end

  def test_strip_space
    assert_equal [head(1,"aaa")],parse("*  aaa         ")
  end

  def test_long
    assert_equal [head(100,"aaa")],parse("#{'*'*100}aaa")
  end

  def head level,str
    Head.new level,[Text.new(str)]
  end
end
