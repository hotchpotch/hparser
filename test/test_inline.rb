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
    assert_not_equal [Text.new('<a href="#"></a>id:secondlife</a>')],
                     parse('<a href="#"></a>id:secondlife</a>')
  end

  def test_id
    assert_equal [Text.new("id:_ql")],parse("id:_ql")
    assert_equal [HatenaId.new("secondlife")],parse("id:secondlife")
  end

  def test_comment
    assert_equal [Text.new("aaa "), Comment.new(" bbb ")], parse("aaa <!-- bbb -->")
  end
end
