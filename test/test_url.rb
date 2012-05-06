require 'test_helper'
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

  def test_new
    url = Url.new("http://example.com")
    assert_equal "http://example.com", url.url
    assert_equal "http://example.com", url.title
    assert_equal false, url.bookmark

    url = Url.new("http://example.com", "TITLE")
    assert_equal "http://example.com", url.url
    assert_equal "TITLE", url.title
    assert_equal false, url.bookmark

    url = Url.new("http://example.com", "")
    assert_equal "http://example.com", url.url
    assert_equal "(undefined)", url.title
    assert_equal false, url.bookmark

    url = Url.new("http://example.com", "a", true)
    assert_equal "http://example.com", url.url
    assert_equal "a", url.title
    assert_equal true, url.bookmark
  end

  def test_http
    assert_equal [Url.new("http://example.com")],parse("http://example.com")
  end

  def test_text
    assert_equal [Text.new("<em>"),Url.new("http://example.com"),Text.new("</em>")],
                 parse("<em>http://example.com</em>")
    assert_equal [Text.new("<em>"),Url.new("http://example.com/?foo=bar&bar=baz"),Text.new("</em>")],
                 parse("<em>http://example.com/?foo=bar&bar=baz</em>")
    assert_equal [Url.new("http://foo.com"),Text.new(" is dummy")],
                 parse("http://foo.com is dummy")
  end

  def test_a
    assert_equal [Text.new("<a>http://example.com</a>")],parse("<a>http://example.com</a>")
  end

  def test_https
    assert_equal [Url.new("https://example.com")],parse("https://example.com")
  end

  def test_bracket
    assert_equal "b", Url.new("a", "b").title
    assert_equal [Url.new("http://example.com", "TITLE")],parse("[http://example.com:title=TITLE]")
    assert_equal [Url.new("http://example.com", "")],parse("[http://example.com:title]")
    assert_equal [Url.new("http://example.com")],parse("[http://example.com]")
    assert_equal [Url.new("http://example.com", "", true)],parse("[http://example.com:title:bookmark]")
    assert_equal [Url.new("http://example.com", "TITLE", true)],parse("[http://example.com:title=TITLE:bookmark]")
  end
end
