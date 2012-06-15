require 'test_helper'
require 'hparser/inline/all'
require 'hparser/html'

class HtmlInlineTest < Test::Unit::TestCase
  include HParser::Inline
  def setup
    @parser = Parser.new
  end

  def assert_html expect,str
    expect.class == String and (expect = [expect])

    assert_equal expect,@parser.parse(str).map{|x| x.to_html}
  end

  def assert_same str
    assert_html [str],str
  end

  def test_text
    assert_same 'foo is bar'
    assert_same '<a href="http://mzp.sakura.ne.jp">link!</a>'
    assert_same "<img src='http://example.com/' />"
    assert_same '<img src="http://example.com/" />'
    assert_same '<iframe src="http://example.com/"></iframe>'
    assert_same '<a href="http://example.com/"></a>'
  end

  def test_id
    assert_html '<a href="http://d.hatena.ne.jp/mzp/">id:mzp</a>','id:mzp'
  end

  def test_url
    assert_html '<a href="http://mzp.sakura.ne.jp">http://mzp.sakura.ne.jp</a>',
                'http://mzp.sakura.ne.jp'
    assert_html '<a href="http://example.com/">TITLE</a>',
                '[http://example.com/:title=TITLE]'
    assert_html '<a href="http://example.com/#a">TITLE</a> ' + 
                '<a href="http://b.hatena.ne.jp/entry/http://example.com/%23a" class="http-bookmark">' + 
                '<img src="http://b.hatena.ne.jp/entry/image/http://example.com/%23a" alt="" class="http-bookmark"></a>',
                '[http://example.com/#a:title=TITLE:bookmark]'
  end
end
