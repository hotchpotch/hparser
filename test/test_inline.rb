require 'test_helper'
require 'hparser/inline/url'
require 'hparser/inline/text'
require 'hparser/inline/hatena_id'
require 'hparser/inline/parser'

class InlineTest < Test::Unit::TestCase
  include HParser::Inline
  def setup
    @inline = Parser.new
  end

  def parse str
    @inline.parse str
  end

  def test_text
    assert_equal [Text.new("foo is bar")],parse("foo is bar")
    assert_equal [Text.new("foo\nbar")],parse("foo\nbar")
  end
end
