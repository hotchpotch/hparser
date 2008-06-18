require 'test/unit'
require 'hparser/inline/parser'
require 'hparser/inline/url'

class UrlTest < Test::Unit::TestCase
  include HParser::Inline
  def setup
    @parser = Parser.new [Url,Text]
  end

  def parse str
    @parser.parse str
  end

  def test_http
    assert_equal [Url.new("http://example.com")],parse("http://example.com")
  end

  def test_text
    assert_equal [Text.new("<em>"),Url.new("http://example.com"),Text.new("</em>")],
                 parse("<em>http://example.com</em>")

    assert_equal [Url.new("http://foo.com"),Text.new(" is dummy")],
                 parse("http://foo.com is dummy")
  end

  def test_a
    assert_equal [Text.new("<a>http://example.com</a>")],parse("<a>http://example.com</a>")
  end

  def test_https
    assert_equal [Url.new("https://example.com")],parse("https://example.com")
  end
end
